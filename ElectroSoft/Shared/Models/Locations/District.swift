import Foundation

struct District: Codable, Identifiable, Hashable {
    let id: Int
    let districtName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case districtName = "district"
    }
}
