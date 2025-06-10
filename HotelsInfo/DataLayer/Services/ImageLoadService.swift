import Combine
import Foundation
import UIKit

actor ImageLoadService: ObservableObject {
    static let cache = NSCache<NSURL, UIImage>()

    private var tasks: [URL?: Task<UIImage, Error>] = [:]

    static func configureCache(
        totalCostLimit: Int = 100_000_000,
        countLimit: Int = 100
    ) {
        cache.totalCostLimit = totalCostLimit
        cache.countLimit = countLimit
    }

    func load(from url: URL?) async throws -> UIImage? {
        guard let url else { return nil }

        if let cached = Self.cache.object(forKey: url as NSURL) {
            return cached
        }

        let task = Task { @MainActor in
            do {
                let (data, response) = try await URLSession.shared.data(from: url)

                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else { throw URLError(.badServerResponse) }

                try Task.checkCancellation()

                guard let image = UIImage(data: data) else {
                    throw URLError(.cannotDecodeContentData)
                }

                Self.cache.setObject(image, forKey: url as NSURL, cost: data.count)

                return image
            } catch {
                throw error
            }
        }

        tasks[url] = task

        do {
            let result = try await task.value
            tasks.removeValue(forKey: url)
            return result
        } catch {
            tasks.removeValue(forKey: url)
            throw error
        }
    }

    func cancel(for url: URL?) {
        tasks.removeValue(forKey: url)?.cancel()
    }

    func cancelAll() {
        for task in tasks.values {
            task.cancel()
        }
        tasks.removeAll()
    }
}
