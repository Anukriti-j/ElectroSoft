import Foundation

struct RoleData: Identifiable {
    let id = UUID()
    let name: String
    let value: Double
}

let mockRoles: [RoleData] = [
    .init(name: "Workers", value: 120),
    .init(name: "State Heads", value: 25),
    .init(name: "City Heads", value: 40),
    .init(name: "District Heads", value: 35),
    .init(name: "Support Team", value: 60),
    .init(name: "Representatives", value: 45),
    .init(name: "Clients", value: 150)
]
