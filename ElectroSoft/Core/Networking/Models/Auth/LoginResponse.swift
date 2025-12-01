import Foundation

struct LoginResponse: Codable {
    let userDetails: UserDetails
    let accessToken, refreshToken: String

    enum CodingKeys: String, CodingKey {
        case userDetails = "user_details"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

struct UserDetails: Codable {
    let id, name, contactNo, userType: String
    let roles: [String]

    enum CodingKeys: String, CodingKey {
        case id, name
        case contactNo = "contact_no"
        case userType = "user_type"
        case roles
    }
}
