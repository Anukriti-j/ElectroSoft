import Foundation

final class AddEmployeeRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func loadPermittedRoles() async throws -> [CreateRoles] {
        let endpoint = PermittedRolesEndpoint.premittedRoles
        let response: APIResponse<[CreateRoles]> =
        try await apiClient.request(endpoint: endpoint, responseType: [CreateRoles].self)
        guard let data = response.data else {
            throw NSError(domain: "Auth", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: response.errorMessage ?? "Login failed"])
        }
        return data
    }
}
