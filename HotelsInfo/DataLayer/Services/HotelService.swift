import Foundation

protocol IHotelService: API {
    func fetchHotels() async throws -> [HotelModel]
    func fetchHotel(id: String) async throws -> HotelModel
}

final class HotelService: IHotelService {
    let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func fetchHotels() async throws -> [HotelModel] {
        let url = baseURL.appending(path: "/iMofas/ios-android-test/master/0777.json")

        return try await performRequest(from: url)
    }

    func fetchHotel(id: String) async throws -> HotelModel {
        let url = baseURL.appending(path: "/iMofas/ios-android-test/master/\(id).json")
                        
        return try await performRequest(from: url)
    }
}
