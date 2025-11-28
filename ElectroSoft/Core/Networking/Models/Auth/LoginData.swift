import Foundation

struct LoginData: Codable {
    let id: String
    let name: String
    let email: String
    let role: String
    let accessToken: String
    let refreshToken: String
    let phoneNumber: String?
    let address: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email, role, address
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case phoneNumber = "phone_number"
    }
}
