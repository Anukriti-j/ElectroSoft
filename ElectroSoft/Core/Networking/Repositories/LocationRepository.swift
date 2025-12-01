
import Foundation

protocol LocationRepositoryProtocol {
    func getStates() async throws -> [States]
    func getDistricts(stateId: Int) async throws -> [District]
    func getCities(districtId: Int) async throws -> [City]
}

final class LocationRepository: LocationRepositoryProtocol {
    private let apiClient: APIClient

    init(api: APIClient) {
        self.apiClient = api
    }
    
    func getStates() async throws -> [States] {
        let response: APIResponse<[States]> = try await apiClient.request(
            endpoint: LocationEndpoints.getStates, responseType: [States].self
        )
        return response.data ?? []
    }

    func getDistricts(stateId: Int) async throws -> [District] {
        let response: APIResponse<[District]> = try await apiClient.request(
            endpoint: LocationEndpoints.getDistricts(stateId: stateId), responseType: [District].self
        )
        return response.data ?? []
    }

    func getCities(districtId: Int) async throws -> [City] {
        let response: APIResponse<[City]> = try await apiClient.request(
            endpoint: LocationEndpoints.getCities(districtId: districtId), responseType: [City].self
        )
        return response.data ?? []
    }
}
