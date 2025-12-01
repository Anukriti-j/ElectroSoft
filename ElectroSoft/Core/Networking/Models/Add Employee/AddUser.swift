import Foundation

struct AddUser: Codable {
    let id: Int
    let roleName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case roleName = "roleName"
    }
}
