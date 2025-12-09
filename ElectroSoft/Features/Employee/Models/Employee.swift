
import Foundation

struct Employee: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let role: String
    let status: String
    let state: String?
    let district: String?
    let city: String?
    
    var isActive: Bool {
        status.lowercased() == "active"
    }
}

struct EmployeeListResponse: Codable {
    let content: [Employee]
    let totalPages: Int
    let totalElements: Int
    let size: Int
    let number: Int 
}
