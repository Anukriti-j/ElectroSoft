import SwiftUI

struct RootView: View {
    @Environment(\.colorScheme) private var systemScheme
    @EnvironmentObject private var theme: ThemeManager
    @EnvironmentObject private var session: SessionManager
    @StateObject private var networkMonitor = NetworkMonitor()
    
    var body: some View {
        Group {
            if networkMonitor.isConnected {
                if session.isLoggedIn {
                    MainTabView()
                } else {
                    LoginView()
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
