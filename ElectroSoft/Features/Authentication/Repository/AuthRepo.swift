import Foundation

final class AuthRepository {
    private let api: APIClient
    private let session: SessionManager
    
    init(api: APIClient, session: SessionManager) {
        self.api = api
        self.session = session
    }
    
    func login(email: String, password: String) async throws -> LoginResponse {
        let endpoint = AuthEndpoints.login(email: email, password: password)
        
        let response: APIResponse<LoginResponse> =
        try await api.request(endpoint: endpoint, responseType: LoginResponse.self)
        
        if response.success {
            if let user = response.data?.userDetails {
                await session.setUpUserSession(user: user)
            }
            
            if let accessToken = response.data?.accessToken, let refreshToken = response.data?.refreshToken {
                await session.saveToken(accessToken: accessToken, refreshToken: refreshToken)
            }
        }
        guard let data = response.data else {
            throw NSError(domain: "Auth", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: response.errorMessage ?? "Login failed"])
        }
        return data
    }
}
