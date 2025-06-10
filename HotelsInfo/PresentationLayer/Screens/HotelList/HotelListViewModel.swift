import Foundation
import Combine

enum HotelSorting {
    case `default`
    case availableRooms(ascending: Bool)
    case distance(ascending: Bool)
}

final class HotelListViewModel: ObservableObject {
    @Published private(set) var hotels: [Hotel] = []
    @Published var isLoading = false
    @Published var error: APIError?
    @Published var searchText = ""
    @Published var currentSorting: HotelSorting = .default
    
    private var originalHotels: [Hotel] = []
    private var subscriptions = Set<AnyCancellable>()

    @Inject private var hotelService: any IHotelService

    init() {
        bind()
    }
    
    func fetchHotels() {
        isLoading = true
        error = nil
        
        Task { @MainActor [weak self] in
            guard let self else { return }
            
            do {
                hotels = try await hotelService.fetchHotels().map { .init(model: $0) }
                originalHotels = hotels
                isLoading = false
            } catch let error as APIError {
                self.error = error
                isLoading = false
            } catch {
                self.error = .unknown(error)
                isLoading = false
            }
        }
    }
    
    func resetToDefault() {
        hotels = originalHotels
        currentSorting = .default
    }

    private func bind() {
        $searchText.sink { [weak self] text in
            self?.filterHotels()
        }
        .store(in: &subscriptions)
    }

    private func filterHotels() {
        var result = originalHotels

        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.address.localizedCaseInsensitiveContains(searchText)
            }
        }

        return switch currentSorting {
        case .default:
            hotels = result
        case let .availableRooms(ascending):
            hotels = result.sorted { ascending
                ? $0.availableRooms.count < $1.availableRooms.count
                : $0.availableRooms.count > $1.availableRooms.count
            }
        case let .distance(ascending):
            hotels = result.sorted {
                ascending
                ? $0.distance < $1.distance
                : $0.distance > $1.distance
            }
        }
    }

    enum State {
        case idle
        case loading
        case result([Hotel])
        case error(Error)
    }
}
