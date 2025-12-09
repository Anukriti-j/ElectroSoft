import Foundation

struct City: Codable, Identifiable, Hashable {
    let id: Int
    let cityName: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case cityName = "city"
    }
}
