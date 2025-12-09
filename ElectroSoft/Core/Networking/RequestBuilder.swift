import Foundation

struct RequestBuilder {
    
    func build(from endpoint: Endpoint, baseURL: String, token: String?) throws -> URLRequest {
        
        guard let url = URL(string: baseURL + endpoint.path) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        
        request.setValue(APIConstants.jsonContentType, forHTTPHeaderField: APIConstants.acceptHeader)
        
        if let contentType = endpoint.contentType {
            request.setValue(contentType, forHTTPHeaderField: APIConstants.contentTypeHeader)
        } else {
            request.setValue(APIConstants.jsonContentType, forHTTPHeaderField: APIConstants.contentTypeHeader)
        }
        
        if endpoint.requiresAuth, let token {
            request.setValue("\(APIConstants.bearer) \(token)",
                             forHTTPHeaderField: APIConstants.authorizationHeader)
        }
        
        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
}
