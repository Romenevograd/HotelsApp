import Foundation

enum APIError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case decoding(Error)
    case unknown(Error)
}
