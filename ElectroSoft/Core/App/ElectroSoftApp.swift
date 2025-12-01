import SwiftUI

@main
struct InventoryApp: App {

    private let keychain = KeyChainManager()
    private let apiClient: APIClient
    private let locationRepo: LocationRepository
    private let session: SessionManager
    private let authRepo: AuthRepository
    private let addEmployeeRepo: AddEmployeeRepository

    @StateObject var themeManager = ThemeManager()

    init() {
        self.apiClient = APIClient(keychain: keychain)
        self.session = SessionManager(keychain: keychain)
        self.authRepo = AuthRepository(api: apiClient, session: session)
        self.locationRepo = LocationRepository(api: apiClient)
        self.addEmployeeRepo = AddEmployeeRepository(apiClient: apiClient)
    }

    var body: some Scene {
        WindowGroup {
            RootView(locationRepo: locationRepo, authRepo: authRepo, addEmployeeRepo: addEmployeeRepo)
                .environmentObject(session)
                .environmentObject(themeManager)
        }
    }
}
