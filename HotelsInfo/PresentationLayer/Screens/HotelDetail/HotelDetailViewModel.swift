import Foundation
import SwiftUI

final class HotelDetailViewModel: ObservableObject {
    @Published private(set) var hotelDetails: Hotel?
    @Published private(set) var imageState: State = .idle
    
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    let hotel: Hotel

    @Inject private var hotelService: any IHotelService
    @Inject private var imageLoadService: ImageLoadService
    @Inject private var mediaResizingManager: any IMediaResizeManager

    private var task: Task<Void, Never>?
    
    init(
        hotel: Hotel
    ) {
        self.hotel = hotel
    }
    
    func perform() {
        guard !isLoading else { return }

        isLoading = true
        error = nil
        imageState = .loading

        task = Task { @MainActor [weak self] in
            guard let self else {
                self?.imageState = .idle
                return
            }

            do {
                let model = try await hotelService.fetchHotel(id: hotel.id.description)
                hotelDetails = .init(model: model)
                isLoading = false

                let image = try await imageLoadService.load(from: hotelDetails?.imageURL)

                guard let imageData = image?.pngData() else {
                    imageState = .idle
                    return
                }

                guard let resized = await mediaResizingManager.resize(imageData: imageData, padding: 1) else {
                    imageState = .idle
                    return
                }

                imageState = .success(resized)
            } catch {
                imageState = .failure(error)
                isLoading = false
                self.error = error
            }
        }
    }
    
    func cancel() {
        isLoading = true
        error = nil
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
