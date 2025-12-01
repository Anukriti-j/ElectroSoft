import Foundation

protocol NetworkingProtocol {
    func request<T: Codable>(
        endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> APIResponse<T>
}

final class APIClient: NetworkingProtocol {
    
    private let keychain: KeyChainManaging

    init(keychain: KeyChainManaging) {
        self.keychain = keychain
    }

    func request<T: Codable>(
        endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> APIResponse<T> {

        var request = endpoint.urlRequest(baseURL: APIConstants.baseURL)
        
        LoggerInterceptor.logRequest(request)

        if endpoint.requiresAuth,
           let token = keychain.read(.accessToken) {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        LoggerInterceptor.logResponse(data: data, response: response)
        let http = response as! HTTPURLResponse

        // Token expired → refresh → retry
        if http.statusCode == 401, endpoint.requiresAuth {
            let refreshed = try await refreshAccessToken()
            if refreshed {
                return try await self.request(endpoint: endpoint, responseType: responseType)
            }
        }

        return try JSONDecoder().decode(APIResponse<T>.self, from: data)
    }

    // MARK: - Refresh Token Flow
    func refreshAccessToken() async throws -> Bool {
        guard let refresh = keychain.read(.refreshToken) else { return false }

        let endpoint = AuthEndpoints.refreshToken(refresh)

        let result: APIResponse<LoginResponse> =
            try await request(endpoint: endpoint, responseType: LoginResponse.self)

        guard result.success, let data = result.data else {
            return false
        }

        keychain.save(.accessToken, value: data.accessToken)
        keychain.save(.refreshToken, value: data.refreshToken)

        return true
    }
}
