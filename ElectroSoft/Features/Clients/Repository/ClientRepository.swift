import Foundation

struct ClientListResponse: Codable {
    let content: [Client]
    let totalPages: Int
}

protocol ClientRepositoryProtocol {
    func fetchClients(
        page: Int,
        search: String?,
        status: String?,
        subscription: String?,
        sortKey: String?,
        sortDirection: String?
    ) async throws -> ClientListResponse
}

final class ClientRepository: ClientRepositoryProtocol {
    
    private let apiClient: APIClient
    
    init(api: APIClient) {
        self.apiClient = api
    }
    
    func fetchClients(
        page: Int,
        search: String?,
        status: String?,
        subscription: String?,
        sortKey: String?,
        sortDirection: String?
    ) async throws -> ClientListResponse {
        
        let endpoint = ClientEndpoints.getAll(
            page: page,
            size: 10,
            search: search,
            status: status,
            subscription: subscription,
            sortKey: sortKey,
            sortDirection: sortDirection
        )
        
        let apiResponse: APIResponse<ClientListResponse> = try await apiClient.request(
            endpoint: endpoint,
            responseType: ClientListResponse.self
        )
        
        guard let data = apiResponse.data else {
            let message = apiResponse.errorMessage ?? "Failed to fetch clients."
            throw APIError.serverMessage(message)
        }
        
        return data
    }
}
