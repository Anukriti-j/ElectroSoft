import Foundation

enum UserType: String, Codable {
    case service = "service"
    case client = "client"
    case customer = "customer"
    case unknown = "unknown"
}

extension UserType {
    init(raw: String) {
        self = UserType(rawValue: raw) ?? .unknown
    }
}
