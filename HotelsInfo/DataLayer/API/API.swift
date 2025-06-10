import Foundation

protocol API {}

extension API {
    func performRequest<T: Decodable>(from url: URL) async throws -> T {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw APIError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            throw APIError.decoding(decodingError)
        } catch {
            throw APIError.invalidData
        }
    }
}
