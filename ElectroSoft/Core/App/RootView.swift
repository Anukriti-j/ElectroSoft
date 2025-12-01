import SwiftUI

struct RootView: View {
    @Environment(\.colorScheme) private var systemScheme
    @EnvironmentObject private var theme: ThemeManager
    @EnvironmentObject private var session: SessionManager
    @StateObject private var networkMonitor = NetworkMonitor()
    let locationRepo: LocationRepository
    let authRepo: AuthRepository
    let addEmployeeRepo: AddEmployeeRepository
    
    init(locationRepo: LocationRepository, authRepo: AuthRepository, addEmployeeRepo: AddEmployeeRepository) {
        self.locationRepo = locationRepo
        self.authRepo = authRepo
        self.addEmployeeRepo = addEmployeeRepo
    }
    
    var body: some View {
        Group {
            if networkMonitor.isConnected {
                if session.isLoggedIn {
                    MainTabView(locationRepo: locationRepo, addEmployeeRepo: addEmployeeRepo)
                } else {
                    LoginView(authRepo: authRepo)
                        .onAppear {
                            syncThemeWithSystem()
                            session.restoreSession()}
                        .onChange(of: systemScheme) { _,_ in syncThemeWithSystem() }
                }
            } else {
                NoInternetView()
            }
        }
        .animation(.easeInOut, value: networkMonitor.isConnected)
        .transition(.opacity)
    }
    
    private func syncThemeWithSystem() {
        theme.currentTheme = (systemScheme == .dark ? .dark : .light)
    }
}

//
//#Preview {
//    RootView()
//        .environment(ThemeManager())
//        .environment(SessionManager(keychain: KeyChainManager(), authRepo: AuthRepository(api: APIClient(keychain: KeyChainManager()))))
//}
