import Foundation

struct Hotel: Identifiable, Hashable {
    let id: Int
    let name: String
    let imageURL: URL?
    let address: String
    let stars: Double
    let distance: String
    let suitesAvailability: String
    let availableRooms: [String]

    init(model: HotelModel) {
        self.id = model.id
        self.name = model.name
        self.address = model.address
        self.stars = model.stars
        self.distance = String(format: "%.1f hotel.distance".localized, model.distance)
        self.suitesAvailability = model.suitesAvailability
        self.availableRooms = suitesAvailability.components(separatedBy: ":")
        self.imageURL = URL(string: "https://github.com/iMofas/ios-android-test/raw/master/\(model.image ?? "")")
    }
}
