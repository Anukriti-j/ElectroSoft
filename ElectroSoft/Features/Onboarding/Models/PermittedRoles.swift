import Foundation

struct CreateRoles: Codable, Identifiable {
    let id: Int
    let createRoleName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "createRoleId"
        case createRoleName = "createRoleName"
    }
}
