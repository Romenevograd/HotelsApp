import Foundation

enum AppRoute: Hashable {
    case splash
    case hotel(HotelRoute)

    enum HotelRoute: Hashable {
        case list
        case detail(Hotel)
    }
}
