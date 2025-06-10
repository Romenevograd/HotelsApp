import SwiftUI

final class AppRouter: ObservableObject {
    @Published var path: [AppRoute] = []

    init(path: [AppRoute]) {
        self.path = path
    }

    func push(_ route: AppRoute) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }

        path.removeLast()
    }

    func popToRoot() {
        path.removeAll()
    }
}
