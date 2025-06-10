import Foundation

struct HotelModel: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let address: String
    let stars: Double
    let distance: Double
    let image: String?
    let suitesAvailability: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, address, stars, distance, image
        case suitesAvailability = "suites_availability"
    }
    
    var formattedDistance: String {
        String(format: "%.1f км от центра города", distance)
    }
    
    var availableRooms: [String] {
        suitesAvailability.components(separatedBy: ":")
    }
    
    var availableRoomsCount: Int {
        availableRooms.count
    }
    
    var imageLink: String? {
        guard let image else { return nil }
        
        return "https://github.com/iMofas/ios-android-test/raw/master/\(image)"
    }
}
