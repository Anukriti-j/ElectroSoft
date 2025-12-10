import Foundation

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> LoginResponse
    func mockLogin() async 
}

final class AuthRepository: AuthRepositoryProtocol {
    private let api: APIClient
    private let session: SessionManager
    
    init(api: APIClient, session: SessionManager) {
        self.api = api
        self.session = session
    }
    
    func login(email: String, password: String) async throws -> LoginResponse {
        let endpoint = AuthEndpoints.login(email: email, password: password)
        
        let response: APIResponse<LoginResponse> = try await api.request(
            endpoint: endpoint,
            responseType: LoginResponse.self
        )
        
        guard response.success, let data = response.data else {
            if let errorMessage = response.errorMessage {
                throw APIError.serverMessage(errorMessage)
            } else {
                throw ErrorMessages.invalidCredential
            }
        }
        
        await session.setUpUserSession(user: data.userDetails)
        await session.saveToken(accessToken: data.accessToken, refreshToken: data.refreshToken)
        
        return data
    }
    
    @MainActor
    func mockLogin() {
        session.isLoggedIn = true
        session.restoreSession()
    }
}
