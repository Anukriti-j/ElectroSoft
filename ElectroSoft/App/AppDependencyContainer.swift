import Foundation

@MainActor
final class AppDependencyContainer: ObservableObject {
    
    let keychain: KeyChainManaging
    let apiClient: APIClient
    let sessionManager: SessionManager
    let themeManager: ThemeManager
    let networkMonitor: NetworkMonitor
    
    let authRepository: AuthRepositoryProtocol
    let locationRepository: LocationRepository
    let addEmployeeRepository: AddEmployeeRepositoryProtocol
    let employeeRepository: EmployeeRepositoryProtocol
    let clientRepository: ClientRepositoryProtocol
    
    init() {
        let sharedKeychain = KeyChainManager()
        let client = APIClient(keychain: sharedKeychain)
        
        self.keychain = sharedKeychain
        self.apiClient = client
        self.themeManager = ThemeManager()
        self.networkMonitor = NetworkMonitor()
        self.sessionManager = SessionManager(keychain: sharedKeychain)
        
        self.authRepository = AuthRepository(api: client, session: sessionManager)
        self.locationRepository = LocationRepository(api: client)
        self.addEmployeeRepository = AddEmployeeRepository(api: client)
        self.employeeRepository = EmployeeRepository(api: client)
        self.clientRepository = ClientRepository(api: client)
    }
}
