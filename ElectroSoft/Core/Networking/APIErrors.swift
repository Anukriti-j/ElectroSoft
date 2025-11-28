import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case unauthorized
    case notFound
    case invalidData
    case serverError(message: String)
    case serverMessage(String)
    case forbidden
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return ErrorMessages.invalidURL
        case .invalidResponse: return ErrorMessages.invalidResponse
        case .decodingError: return ErrorMessages.decodingError
        case .unauthorized: return ErrorMessages.unauthorized
        case .notFound: return ErrorMessages.notFound
        case .serverError(let message): return message
        case .serverMessage(let message): return message
        case .forbidden: return ErrorMessages.forbidden
        case .unknown: return ErrorMessages.unknown
        case .invalidData: return ErrorMessages.invalidData
        }
    }
}
