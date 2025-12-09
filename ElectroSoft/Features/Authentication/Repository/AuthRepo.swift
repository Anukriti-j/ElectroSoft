import Foundation

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> LoginResponse
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
            let errorMessage = response.errorMessage ?? "Invalid email or password."
            throw APIError.serverMessage(errorMessage)
        }
        
        await session.setUpUserSession(user: data.userDetails)
        await session.saveToken(accessToken: data.accessToken, refreshToken: data.refreshToken)
        
        return data
    }
}
