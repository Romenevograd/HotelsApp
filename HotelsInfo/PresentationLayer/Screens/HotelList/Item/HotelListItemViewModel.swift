import Combine
import Foundation
import UIKit

final class HotelListItemViewModel: ObservableObject {
    @Published private(set) var imageState: State = .idle

    let hotel: Hotel

    @Inject private var hotelService: any IHotelService
    @Inject private var imageLoadService: ImageLoadService
    @Inject private var mediaResizingManager: any IMediaResizeManager

    private var hotelDetails: Hotel?
    private var task: Task<Void, Never>?

    init(
        hotel: Hotel
    ) {
        self.hotel = hotel
    }

    func fetchHotel() {
        cancel()

        imageState = .loading

        task = Task { @MainActor [weak self] in
            guard let self else {
                self?.imageState = .idle
                return
            }

            do {
                let model = try await hotelService.fetchHotel(id: hotel.id.description)
                hotelDetails = .init(model: model)

                let image = try await imageLoadService.load(from: hotelDetails?.imageURL)

                guard let imageData = image?.pngData() else {
                    imageState = .idle
                    return
                }

                guard let resized = await self.mediaResizingManager.resize(imageData: imageData, padding: 1) else {
                    imageState = .idle
                    return
                }

                imageState = .success(resized)
            } catch {
                imageState = .failure(error)
            }
        }
    }

    func cancel() {
        task?.cancel()
        Task { @MainActor in
            await imageLoadService.cancel(for: hotelDetails?.imageURL)
        }
    }

    enum State {
        case idle
        case loading
        case success(UIImage)
        case failure(Error)
    }
}
