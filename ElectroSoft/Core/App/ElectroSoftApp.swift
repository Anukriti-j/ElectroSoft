import SwiftUI

@main
struct InventoryApp: App {

    private let keychain = KeyChainManager()
    @StateObject var themeManager = ThemeManager()
    
    var body: some Scene {
        let apiClient = APIClient(keychain: keychain)
        let authRepo = AuthRepository(api: apiClient)
        let session = SessionManager(keychain: keychain, authRepo: authRepo)

        WindowGroup {
            RootView()
                .environmentObject(session)
                .environmentObject(themeManager)
        }
    }
}
