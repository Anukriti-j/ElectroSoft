import Foundation

struct RequestBuilder {
    
    func build(from endpoint: Endpoint, baseURL: String, token: String?) throws -> URLRequest {
        
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        
        // Default headers
        request.setValue(APIConstants.jsonContentType, forHTTPHeaderField: APIConstants.acceptHeader)
        
        // Use endpoint content type if given, fallback to JSON
        if let contentType = endpoint.contentType {
            request.setValue(contentType, forHTTPHeaderField: APIConstants.contentTypeHeader)
        } else {
            request.setValue(APIConstants.jsonContentType, forHTTPHeaderField: APIConstants.contentTypeHeader)
        }
        
        // Add token only if required
        if endpoint.requiresAuth, let token {
            request.setValue("\(APIConstants.bearer) \(token)",
                             forHTTPHeaderField: APIConstants.authorizationHeader)
        }
        
        // Additional custom headers
        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}
