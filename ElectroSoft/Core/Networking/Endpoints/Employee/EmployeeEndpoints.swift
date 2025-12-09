import Foundation

enum EmployeeEndpoints {
    case getAll(
        page: Int,
        size: Int,
        search: String?,
        roles: Set<String>?,
        statuses: Set<String>?,
        sortBy: String?,
        sortDirection: String?
    )
    case delete(id: Int)
}

extension EmployeeEndpoints: Endpoint {
    
    var path: String {
        switch self {
        case .getAll:
            return buildPathWithQueryItems()
        case .delete(let id):
            return "/owner/employee/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAll: return .GET
        case .delete: return .DELETE
        }
    }
    
    var body: Data? { nil }
    var contentType: String? { nil }
    var headers: [String : String] { [:] }
    var requiresAuth: Bool { true }
    
    private func buildPathWithQueryItems() -> String {
        var components = URLComponents(string: "/owner/employees")!
        
        guard case .getAll(let page, let size, let search, let roles, let statuses, let sortBy, let sortDirection) = self else {
            return components.path
        }
        
        var queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "size", value: "\(size)")
        ]
        
        if let search, !search.isEmpty {
            queryItems.append(URLQueryItem(name: "search", value: search))
        }
        
        roles?.forEach { role in
            queryItems.append(URLQueryItem(name: "role", value: role))
        }
        
        statuses?.forEach { status in
            queryItems.append(URLQueryItem(name: "status", value: status))
        }
        
        if let sortBy {
            queryItems.append(URLQueryItem(name: "sortBy", value: sortBy))
        }
        
        if let sortDirection {
            queryItems.append(URLQueryItem(name: "sortDirection", value: sortDirection))
        }
        
        components.queryItems = queryItems
        
        return components.url!.path + (components.url!.query.map { "?" + $0 } ?? "")
    }
}
