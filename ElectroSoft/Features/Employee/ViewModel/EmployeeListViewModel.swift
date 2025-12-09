import Foundation
import SwiftUI

@MainActor
final class EmployeeListViewModel: ObservableObject {
    
    enum ViewState: Equatable {
        case idle, loading, loaded, error(String), empty
    }
    
    @Published var viewState: ViewState = .idle
    @Published var employees: [Employee] = []
    @Published var searchText = ""
    @Published var filterOptions: [FilterOption] = []
    @Published var filterSelections: [String: String] = [:]
    @Published var sortOptions: [SortOption] = []
    @Published var selectedSort: SortOption?
    
    private let repository: EmployeeRepositoryProtocol
    private let locationRepository: LocationRepositoryProtocol
    private var searchOrFilterTask: Task<Void, Never>?
    private var currentPage = 0
    private var totalPages = 1
    
    init(repository: EmployeeRepositoryProtocol, locationRepository: LocationRepositoryProtocol) {
        self.repository = repository
        self.locationRepository = locationRepository
        configureFilters()
        configureSorts()
    }
    
    var hasMorePages: Bool { currentPage < totalPages }
    
    func loadInitialData() async {
        await fetchEmployees(reset: true)
    }
    
    func fetchEmployees(reset: Bool = false) async {
        if reset {
            currentPage = 0
            totalPages = 1
            employees = []
        }
        
        guard currentPage < totalPages, viewState != .loading else { return }
        
        if currentPage == 0 { viewState = .loading }
        
        do {
            let status = filterSelections["status"]
            let role = filterSelections["role"]
            
            let response = try await repository.fetchEmployees(
                page: currentPage,
                search: searchText.isEmpty ? nil : searchText,
                roles: role == "All" ? nil : [role ?? ""],
                statuses: status == "All" ? nil : [status ?? ""],
                sortBy: selectedSort?.serverKey,
                sortDirection: selectedSort?.direction
            )
            
            if reset {
                employees = response.content
            } else {
                employees.append(contentsOf: response.content)
            }
            
            totalPages = response.totalPages
            currentPage += 1
            viewState = employees.isEmpty ? .empty : .loaded
        } catch {
            viewState = .error("Failed to load employees")
            employees = generateDummyData()
        }
    }
    
    func refresh() async {
        await fetchEmployees(reset: true)
    }
    
    func refreshWithoutCancel() async {
        await refresh()
    }
    
    func loadNextPageIfNeeded(currentItem: Employee) async {
        if currentItem.id == employees.last?.id && hasMorePages {
            await fetchEmployees()
        }
    }
    
    func updateSearchText(_ text: String) {
        searchText = text
        applySearchOrFilter()
    }
    
    func applyFilters(_ updated: [String: String]) {
        filterSelections = updated
        applySearchOrFilter()
    }
    
    func applySort(_ sort: SortOption?) {
        selectedSort = sort
        Task { await fetchEmployees(reset: true) }
    }
    
    func deleteEmployee(_ employee: Employee) {
        employees.removeAll { $0.id == employee.id }
    }
    
    private func applySearchOrFilter() {
        searchOrFilterTask?.cancel()
        searchOrFilterTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            await fetchEmployees(reset: true)
        }
    }
    
    private func configureFilters() {
        filterOptions = [
            FilterOption(key: "role", title: "Role", values: ["All", "Statehead", "Districthead", "Cityhead", "Support", "Worker"]),
            FilterOption(key: "status", title: "Status", values: ["All", "Active", "Inactive"])
        ]
        
        filterSelections = [
            "role": "All",
            "status": "All"
        ]
    }
    
    private func configureSorts() {
        sortOptions = [
            SortOption(id: "name_asc", displayName: "Name A–Z", serverKey: "name", direction: .ascending),
            SortOption(id: "name_desc", displayName: "Name Z–A", serverKey: "name", direction: .descending)
        ]
        selectedSort = sortOptions.first
    }
    
    private func generateDummyData() -> [Employee] {
        [
            Employee(id: 1, name: "Rahul Sharma", email: "rahul@electro.com", phone: "9876543210", role: "Statehead", status: "Active", state: "Maharashtra", district: nil, city: nil),
            Employee(id: 2, name: "Anita Desai", email: "anita@electro.com", phone: "9876543211", role: "Districthead", status: "Active", state: "Maharashtra", district: "Pune", city: nil),
            Employee(id: 3, name: "Suresh Patil", email: "suresh@electro.com", phone: "9876543212", role: "Cityhead", status: "Inactive", state: "Maharashtra", district: "Pune", city: "Pune City")
        ]
    }
}
