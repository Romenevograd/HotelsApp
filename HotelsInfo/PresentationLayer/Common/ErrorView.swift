import SwiftUI

struct ErrorView: View {
    let error: APIError
    let retryAction: () -> Void
    
    var errorMessage: String {
        switch error {
        case .invalidURL: "hotel.error.invalid.url".localized
        case .invalidResponse: "hotel.error.serverResponse".localized
        case .invalidData: "hotel.error.incorrectData".localized
        case let .decoding(error): "Ошибка декодирования: \(error.localizedDescription)"
        case let .unknown(error): "Что-то пошло не так: \(error.localizedDescription)"
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.red)
            
            Text("hotel.error")
                .font(.title)
            
            Text(errorMessage)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: retryAction) {
                HStack {
                    Image(systemName: "arrow.clockwise")

                    Text("hotel.repeat")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
