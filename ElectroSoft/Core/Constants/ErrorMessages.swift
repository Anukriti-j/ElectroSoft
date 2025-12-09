import Foundation

enum ErrorMessages: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case unauthorized
    case notFound
    case forbidden
    case unknown
    case invalidData
    case requiredField
    case requiredEmail
    case requiredPassword
    case emptyName
    case invalidEmail
    case invalidPhone
    case requiredPhone
    case invalidCredential
}

extension ErrorMessages {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL."
        case .invalidResponse:
            return "Invalid response from server."
        case .decodingError:
            return "Failed to parse response data."
        case .unauthorized:
            return "Unauthorized request."
        case .notFound:
            return "Resource not found."
        case .forbidden:
            return "You don’t have permission to perform this action."
        case .unknown:
            return "An unknown error occurred."
        case .invalidData:
            return "Data is invalid."
        case .requiredField:
            return "This field is required."
        case .requiredEmail:
            return "Email is required."
        case .requiredPassword:
            return "Password is required."
        case .emptyName:
            return "Name cannot be empty."
        case .invalidEmail:
            return "Invalid email format."
        case .invalidPhone:
            return "Phone number must be 10 digits."
        case .requiredPhone:
            return "Phone number is required."
        case .invalidCredential:
            return "Invalid Credential"
        }
    }
}
