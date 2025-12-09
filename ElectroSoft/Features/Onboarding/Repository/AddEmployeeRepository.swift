import Foundation

protocol AddEmployeeRepositoryProtocol {
    func loadPermittedRoles() async throws -> [CreateRoles]
}

final class AddEmployeeRepository: AddEmployeeRepositoryProtocol {
    private let apiClient: APIClient
    
    init(api: APIClient) {
        self.apiClient = api
    }
    
    func loadPermittedRoles() async throws -> [CreateRoles] {
        let endpoint = PermittedRolesEndpoint.premittedRoles
        
        let response: APIResponse<[CreateRoles]> = try await apiClient.request(
            endpoint: endpoint,
            responseType: [CreateRoles].self
        )
        
        guard let data = response.data else {
            let errorMessage = response.errorMessage ?? "Failed to load permitted roles."
            throw APIError.serverMessage(errorMessage)
        }
        return data
    }
}
