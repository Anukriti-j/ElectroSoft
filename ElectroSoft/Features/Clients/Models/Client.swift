import Foundation

enum ClientStatus: String, Codable, CaseIterable {
    case active = "Active"
    case inactive = "Inactive"
    
    var id: String { self.rawValue }
}

enum SubscriptionPlan: String, Codable, CaseIterable, Identifiable {
    case premium = "Premium"
    case standard = "Standard"
    case basic = "Basic"
    
    var id: String { self.rawValue }
}

struct Client: Codable, Identifiable, Hashable {
    let id: Int
    let clientName: String
    let companyName: String
    let representativeName: String
    let subscriptionPlan: String
    let status: ClientStatus
}
