import Foundation

enum ClientEndpoints {
    case getAll(
        page: Int,
        size: Int,
        search: String?,
        status: String?,
        subscription: String?,
        sortKey: String?,
        sortDirection: String?
    )
}

extension ClientEndpoints: Endpoint {
    
    var path: String {
        switch self {
        case .getAll:
            return buildPathWithQueryItems()
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAll:
            return .GET
        }
    }
    
    var body: Data? {
        return nil
    }
    
    var contentType: String? {
        return nil
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var requiresAuth: Bool {
        return true
    }
    
    private func buildPathWithQueryItems() -> String {
        var components = URLComponents(string: "/clients")!
        
        switch self {
        case .getAll(
            let page,
            let size,
            let search,
            let status,
            let subscription,
            let sortKey,
            let sortDirection
        ):
            var queryItems = [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "size", value: "\(size)")
            ]
            
            if let search, !search.isEmpty {
                queryItems.append(URLQueryItem(name: "search", value: search))
            }
            if let status, status != "All" {
                queryItems.append(URLQueryItem(name: "status", value: status))
            }
            if let subscription, subscription != "All" {
                queryItems.append(URLQueryItem(name: "subscription", value: subscription))
            }
            if let sortKey, !sortKey.isEmpty {
                queryItems.append(URLQueryItem(name: "sortKey", value: sortKey))
            }
            if let sortDirection, !sortDirection.isEmpty {
                queryItems.append(URLQueryItem(name: "sortDirection", value: sortDirection))
            }
            
            components.queryItems = queryItems
        }
        
        return components.url!.path + (components.url!.query.map { "?" + $0 } ?? "")
    }
}
