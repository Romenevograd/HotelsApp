import SwiftUI

struct HotelDetailView: View {
    @StateObject private var viewModel: HotelDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                hotelImage()

                HStack(spacing: 10) {
                    HStack {
                        Text("\(viewModel.hotel.stars, specifier: "%.1f")")
                            .foregroundColor(.white)
                            .padding(5)
                            .background(.backgroundButton)
                            .cornerRadius(15)
                    }

                    Text("\(viewModel.hotel.name)")
                        .foregroundColor(.textHeader)
                        .font(.headline)

                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 5)
                .padding(.horizontal, 5)
                .background(.backgroundHeader)
                .cornerRadius(15)

                Divider()

                VStack(alignment: .leading, spacing: 0) {
                    infoRow(icon: "mappin.and.ellipse", text: viewModel.hotel.address)
                    infoRow(icon: "location", text: viewModel.hotel.distance)
                }
                .lineLimit(1)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 5)
                .padding(.leading)
                .background(.backgroundHeader)
                .cornerRadius(15)

                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.hotel.availableRooms, id: \.self) { room in
                            Button(action: {
                                print("Выбран номер \(room)")
                            }) {
                                Text(room)
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                    .frame(minWidth: 15)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(.backgroundButton)
                                    .cornerRadius(15)
                            }
                        }
                    }
                }
            }
            .padding(.bottom)
        }
        .navigationTitle(viewModel.hotel.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(.backgroundMain)
        .onAppear {
            viewModel.perform()
        }
    }

    init(hotel: Hotel) {
        _viewModel = .init(wrappedValue: .init(hotel: hotel))
    }

    private func hotelImage() -> some View {
        ZStack {
            GeometryReader { geometry in
                switch viewModel.imageState {
                case .idle, .loading:
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 300)
                case let .success(image):
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: 300)
                        .clipped()
                case .failure(_):
                    HStack {
                        Spacer()
                        Image(systemName: "building.2")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .foregroundStyle(.backgroundButton)
                        Spacer()
                    }
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 300)
            .frame(maxWidth: .infinity)
            .background(.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }

    private func infoRow(icon: String, text: String) -> some View {
        HStack(spacing: 2) {
            Image(systemName: icon)
                .foregroundColor(.backgroundButton)
                .frame(width: 15)

            Text(text)
                .font(.system(size: 12))
        }
    }
}
