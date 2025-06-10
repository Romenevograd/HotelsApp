import SwiftUI

@main
struct HotelsApp: App {
    @StateObject private var router = AppRouter(path: [.splash])

    private let dependenciesContainer = DependenciesContainer.shared

    init() {
        bootstrap()
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                EmptyView()
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .splash:
                            ProgressView()
                                .navigationBarBackButtonHidden()
                                .onAppear {
                                    Task {
                                        try? await Task.sleep(for: .seconds(2))

                                        router.popToRoot()
                                        router.push(.hotel(.list))
                                    }
                                }
                        case let .hotel(hotelRoute):
                            switch hotelRoute {
                            case .list:
                                HotelListView(viewModel: .init())
                            case let .detail(hotel):
                                HotelDetailView(hotel: hotel)
                            }
                        }
                    }
            }
            .environmentObject(router)
        }
    }

    private func bootstrap() {
        dependenciesContainer.register(IMediaResizeManager.self) { MediaResizeManager() }
        dependenciesContainer.register(ImageLoadService.self) { ImageLoadService() }
        dependenciesContainer.register(IHotelService.self) { HotelService(baseURL: Environment.baseURL) }
    }
}
