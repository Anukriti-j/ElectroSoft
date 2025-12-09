import Foundation

protocol EmployeeRepositoryProtocol {
    func fetchEmployees(
        page: Int,
        search: String?,
        roles: Set<String>?,
        statuses: Set<String>?,
        sortBy: String?,
        sortDirection: SortDirection?
    ) async throws -> EmployeeListResponse
    
    func deleteEmployee(id: Int) async throws
}

final class EmployeeRepository: EmployeeRepositoryProtocol {
    private let api: APIClient
    
    init(api: APIClient) {
        self.api = api
    }
    
    func fetchEmployees(
        page: Int,
        search: String?,
        roles: Set<String>?,
        statuses: Set<String>?,
        sortBy: String?,
        sortDirection: SortDirection?
    ) async throws -> EmployeeListResponse {
        
        let endpoint = EmployeeEndpoints.getAll(
            page: page,
            size: 10,
            search: search,
            roles: roles,
            statuses: statuses,
            sortBy: sortBy,
            sortDirection: sortDirection?.rawValue
        )
        
        let response: APIResponse<EmployeeListResponse> = try await api.request(
            endpoint: endpoint,
            responseType: EmployeeListResponse.self
        )
        
        guard let data = response.data else {
            let errorMessage = response.errorMessage ?? "Failed to fetch employees."
            throw APIError.serverMessage(errorMessage)
        }
        return data
    }
    
    func deleteEmployee(id: Int) async throws {
        let endpoint = EmployeeEndpoints.delete(id: id)
        
        let response: APIResponse<String> = try await api.request(
            endpoint: endpoint,
            responseType: String.self
        )
        
        if !response.success {
            throw APIError.serverMessage(response.errorMessage ?? "Delete failed")
        }
    }
}
