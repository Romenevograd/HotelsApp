import SwiftUI

struct HotelListView: View {
    @StateObject private var viewModel: HotelListViewModel
    @EnvironmentObject var router: AppRouter

    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                if viewModel.isLoading {
                    ProgressView("hotel.loading")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.error {
                    ErrorView(error: error) {
                        viewModel.fetchHotels()
                    }
                } else {
                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.hotels) { hotel in
                            HotelListItemView(viewModel: .init(hotel: hotel))
                                .background(.backgroundHeader)
                                .cornerRadius(24)
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                .onTapGesture {
                                    router.push(.hotel(.detail(hotel)))
                                }
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                }
            }
        }
        .background(.backgroundMain)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button {
                        viewModel.fetchHotels()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.backgroundButton)
                    }
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("hotels.defaultSort") {
                        viewModel.currentSorting = .default
                    }

                    Button("hotel.distance.closer") {
                        viewModel.currentSorting = .distance(ascending: true)
                    }

                    Button("hotel.distance.further") {
                        viewModel.currentSorting = .distance(ascending: false)
                    }

                    Button("hotel.availableRooms.less") {
                        viewModel.currentSorting = .availableRooms(ascending: true)
                    }

                    Button("hotel.availableRooms.more") {
                        viewModel.currentSorting = .availableRooms(ascending: false)
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .foregroundColor(.backgroundButton)
                }
            }
        }
        .searchable(text: $viewModel.searchText)
        .refreshable {
            viewModel.fetchHotels()
        }
        .onAppear {
            if viewModel.hotels.isEmpty {
                viewModel.fetchHotels()
            }
        }
    }

    init(viewModel: HotelListViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
}
