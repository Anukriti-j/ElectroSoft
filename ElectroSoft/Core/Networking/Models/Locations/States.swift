import Foundation

struct States: Codable, Identifiable {
    let id: Int
    let stateName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case stateName = "state"
    }
}
