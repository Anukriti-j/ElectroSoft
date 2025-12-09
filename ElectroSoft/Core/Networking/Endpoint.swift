import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var body: Data? { get }
    var headers: [String: String] { get }
    var contentType: String? { get }
    var requiresAuth: Bool { get }
    
    func urlRequest(baseURL: String) -> URLRequest
}


extension Endpoint {
    
    func urlRequest(baseURL: String) -> URLRequest {
        
        guard let url = URL(string: baseURL + path) else {
            fatalError("Invalid URL: \(baseURL)\(path)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let contentType {
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        } else {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        request.httpBody = body
        return request
    }
}

