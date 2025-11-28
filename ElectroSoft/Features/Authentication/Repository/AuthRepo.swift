import Foundation

final class AuthRepository {
    private let api: APIClient

    init(api: APIClient) {
        self.api = api
    }

    func login(email: String, password: String) async throws -> LoginData {
        let endpoint = AuthEndpoints.login(email: email, password: password)

        let response: APIResponse<LoginData> =
            try await api.request(endpoint: endpoint, responseType: LoginData.self)

        guard let data = response.data else {
            throw NSError(domain: "Auth", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: response.errorMessage ?? "Login failed"])
        }

        return data
    }
}
