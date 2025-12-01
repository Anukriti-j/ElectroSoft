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
        case .invalidURL: return ErrorMessages.invalidURL.errorDescription
        case .invalidResponse: return ErrorMessages.invalidResponse.errorDescription
        case .decodingError: return ErrorMessages.decodingError.errorDescription
        case .unauthorized: return ErrorMessages.unauthorized.errorDescription
        case .notFound: return ErrorMessages.notFound.errorDescription
        case .serverError(let message): return message
        case .serverMessage(let message): return message
        case .forbidden: return ErrorMessages.forbidden.errorDescription
        case .unknown: return ErrorMessages.unknown.errorDescription
        case .invalidData: return ErrorMessages.invalidData.errorDescription
        }
    }
}
