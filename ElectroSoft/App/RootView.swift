import SwiftUI

struct RootView: View {
    @ObservedObject var container: AppDependencyContainer
    
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var session: SessionManager
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    
    @State private var isRestoringSession = true
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.background
                .ignoresSafeArea()
            
            Group {
                if isRestoringSession {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(themeManager.currentTheme.primary)
                } else {
                    if session.isLoggedIn {
                        MainTabView(
                            container: container
                        )
                        .transition(.opacity)
                    } else {
                        LoginView(container: container)
                            .transition(.move(edge: .bottom))
                    }
                }
            }
            
        }
        .animation(.easeInOut, value: session.isLoggedIn)
        .animation(.easeInOut, value: networkMonitor.isConnected)
        .onAppear {
            handleAppLaunch()
        }
    }
    
    private func handleAppLaunch() {
        Task {
            session.restoreSession()
            try? await Task.sleep(nanoseconds: 500_000_000)
            withAnimation {
                isRestoringSession = false
            }
        }
    }
}

#if DEBUG
#Preview {
    RootView(container: AppDependencyContainer())
        .environmentObject(ThemeManager())
        .environmentObject(SessionManager(keychain: KeyChainManager()))
        .environmentObject(NetworkMonitor())
}
#endif
