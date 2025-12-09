import Foundation

@MainActor
final class ClientListViewModel: ObservableObject {
    
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case error(String)
        case empty
    }
    
    @Published var viewState: ViewState = .idle
    @Published var clients: [Client] = []
    @Published var searchText = ""
    
    @Published var filterOptions: [FilterOption] = []
    @Published var filterSelections: [String: String] = [:]
    
    @Published var sortOptions: [SortOption] = []
    @Published var selectedSort: SortOption?
    
    private let repository: ClientRepositoryProtocol
    private var filterTask: Task<Void, Never>?
    
    var currentPage = 0
    var totalPages = 1
    
    init(repository: ClientRepositoryProtocol) {
        self.repository = repository
        configureFilters()
        configureSorts()
    }
    
    func fetchClients(reset: Bool = false) async {
        if reset {
            currentPage = 0
            totalPages = 1
            clients = []
        }
        
        guard currentPage < totalPages else { return }
        
        if currentPage == 0 {
            viewState = .loading
        }
        
        do {
            let response = try await repository.fetchClients(
                page: currentPage,
                search: searchText.isEmpty ? nil : searchText,
                status: filterSelections["status"] == "All" ? nil : filterSelections["status"],
                subscription: filterSelections["type"] == "All" ? nil : filterSelections["type"],
                sortKey: selectedSort?.serverKey,
                sortDirection: selectedSort?.direction.rawValue
            )
            
            clients.append(contentsOf: sortClients(response.content))
            totalPages = response.totalPages
            currentPage += 1
            
            viewState = clients.isEmpty ? .empty : .loaded
        } catch {
            viewState = .error(error.localizedDescription)
            clients = generateDummyData()
        }
    }
    
    func loadNextPageIfNeeded(currentItem: Client) async {
        guard viewState != .loading,
              let lastClient = clients.last,
              currentItem.id == lastClient.id else { return }
        
        await fetchClients()
    }
    
    func updateSearchText(_ text: String) {
        searchText = text
        triggerSearch()
    }
    
    func applyFilters(_ selections: [String: String]) {
        filterSelections = selections
        triggerSearch()
    }
    
    func applySort(_ sort: SortOption?) {
        selectedSort = sort
        triggerSearch()
    }
    
    private func triggerSearch() {
        filterTask?.cancel()
        filterTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            if !Task.isCancelled {
                await fetchClients(reset: true)
            }
        }
    }
    
    private func sortClients(_ data: [Client]) -> [Client] {
        guard let sort = selectedSort else { return data }
        
        switch sort.id {
        case "name_asc":
            return data.sorted { $0.clientName < $1.clientName }
        case "name_desc":
            return data.sorted { $0.clientName > $1.clientName }
        default:
            return data
        }
    }
    
    func refreshWithoutCancel() async {
        await fetchClients(reset: true)
    }
    
    private func configureFilters() {
        filterOptions = [
            FilterOption(key: "status", title: "Status", values: ["All", "Active", "Inactive"]),
            FilterOption(key: "type", title: "Type", values: ["All", "Premium", "Standard", "Basic"])
        ]
        
        filterSelections = [
            "status": "All",
            "type": "All"
        ]
    }
    
    private func configureSorts() {
        sortOptions = [
            SortOption(
                id: "name_asc",
                displayName: "Name A–Z",
                serverKey: "name",
                direction: .ascending
            ),
            SortOption(
                id: "name_desc",
                displayName: "Name Z–A",
                serverKey: "name",
                direction: .descending
            )
        ]
    }
    
    private func generateDummyData() -> [Client] {
        [
            Client(id: 101, clientName: "Global Tech Inc.", companyName: "Global Tech", representativeName: "Priya Singh", subscriptionPlan: SubscriptionPlan.premium.rawValue, status: .active),
            Client(id: 102, clientName: "Sunrise Industries", companyName: "Sunrise Co.", representativeName: "Amit Kumar", subscriptionPlan: SubscriptionPlan.standard.rawValue, status: .active),
            Client(id: 103, clientName: "Digital Solutions LLC", companyName: "Digital LLC", representativeName: "Priya Singh", subscriptionPlan: SubscriptionPlan.basic.rawValue, status: .inactive)
        ]
    }
}
