import Foundation

protocol NetworkingProtocol {
    func request<T: Codable>(endpoint: Endpoint, responseType: T.Type) async throws -> APIResponse<T>
}

final class APIClient: NetworkingProtocol {
    
    private let keychain: KeyChainManaging
    private let session: URLSession
    
    init(keychain: KeyChainManaging) {
        self.keychain = keychain
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        self.session = URLSession(configuration: config)
    }
    
    func request<T: Codable>(
        endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> APIResponse<T> {
        
        let request = try RequestBuilder().build(
            from: endpoint,
            baseURL: APIConstants.baseURL,
            token: endpoint.requiresAuth ? keychain.read(.accessToken) : nil
        )
        
        LoggerInterceptor.logRequest(request)
        
        let (data, response) = try await session.data(for: request)
        LoggerInterceptor.logResponse(data: data, response: response)
        
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if http.statusCode == 401, endpoint.requiresAuth {
            print("Token expired. Attempting refresh...")
            let refreshed = try await refreshAccessToken()
            
            if refreshed {
                return try await self.request(endpoint: endpoint, responseType: responseType)
            } else {
                throw APIError.unauthorized
            }
        }
        
        do {
            return try JSONDecoder().decode(APIResponse<T>.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
    
    private func refreshAccessToken() async throws -> Bool {
        guard let refreshToken = keychain.read(.refreshToken) else { return false }
        
        let endpoint = AuthEndpoints.refreshToken(refreshToken)
        
        let request = try RequestBuilder().build(
            from: endpoint,
            baseURL: APIConstants.baseURL,
            token: nil
        )
        
        let (data, response) = try await session.data(for: request)
        
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            return false
        }
        
        if let result = try? JSONDecoder().decode(APIResponse<LoginResponse>.self, from: data),
           let tokens = result.data {
            
            keychain.save(.accessToken, value: tokens.accessToken)
            keychain.save(.refreshToken, value: tokens.refreshToken)
            return true
        }
        
        return false
    }
}
