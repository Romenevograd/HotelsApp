import SwiftUI

struct HotelListItemView: View {
    @StateObject private var viewModel: HotelListItemViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 5) {
                ZStack(alignment: .bottomLeading) {
                    hotelImage()
                    
                    HStack(spacing: 0) {
                        Image(systemName: "star")
                            .foregroundColor(.textButton)
                            .font(.system(size: 10, weight: .bold))
                        
                        Text("\(viewModel.hotel.stars, specifier: "%.1f")")
                            .foregroundColor(.textButton)
                            .font(.system(size: 14, weight: .bold))
                    }
                    .frame(width: 40, height: 20)
                    .padding(4)
                    .background(.backgroundButton)
                    .cornerRadius(15)
                    .padding([.leading, .bottom], 8)
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    VStack(alignment: .leading, spacing: 5) {
                        
                        Text(viewModel.hotel.name)
                            .font(.headline)
                            .lineLimit(2)
                        
                        Text(viewModel.hotel.address)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }

                    
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .foregroundColor(.backgroundButton)
                            .font(.system(size: 14))


                        Text(viewModel.hotel.distance)
                            .font(.caption)
                    }
                    .foregroundColor(.gray)
                    

                    Text("hotel.availableRooms.count \(viewModel.hotel.availableRooms.count)")
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(4)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(4)
                }
                .padding(.leading, 10)
                .padding(.vertical, 10)
                Spacer()
            }
        }
        
    
        .frame(height: 150)
        .onAppear {
            viewModel.fetchHotel()
        }
        .onDisappear {
            viewModel.cancel()
        }
        .padding(5)
    }
    
    init(viewModel: HotelListItemViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    private func hotelImage() -> some View {
        Group {
            switch viewModel.imageState {
            case .idle, .loading:
                Rectangle()
                    .fill(.clear)
                    .frame(width: 150, height: 150)
            case let .success(image):
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
            case .failure(_):
                Image(systemName: "building.2")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .padding(.bottom, 20)
                    .foregroundStyle(.backgroundButton)
            }
        }
        .frame(width: 150, height: 150)
        .background(.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .clipped()
    }
}
