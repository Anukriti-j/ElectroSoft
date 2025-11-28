import Foundation

struct Pagination: Codable {
    let size: Int
    let page: Int
    let totalElements: Int
    let totalPages: Int
}

struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let message: String?
    let data: T?
    let pagination: Pagination?
    let error: String?
    let statusCode: Int?
    
    var errorMessage: String? {
        guard success == false else { return nil }
        return message ?? error ?? "Unknown error"
    }
}
