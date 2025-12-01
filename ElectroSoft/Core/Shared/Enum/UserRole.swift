import Foundation

enum Roles: String, Codable, CaseIterable {
    case owner = "Owner"
    case clientHead = "Clienthead"
    case stateHead = "Statehead"
    case districtHead = "Districthead"
    case talukaHead = "Talukahead"
    case support = "Support"
    case worker = "Worker"
    case customer = "Customer"
    case representative = "Representative"
    case unknown = "Unknown"
}

extension Roles {
    init(raw: String) {
        self = Roles(rawValue: raw) ?? .unknown
    }
}

