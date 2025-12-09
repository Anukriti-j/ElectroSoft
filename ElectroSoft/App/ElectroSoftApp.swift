import SwiftUI

@main
struct ElectroSoftApp: App {
    @StateObject private var container = AppDependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            RootView(container: container)
                .environmentObject(container.themeManager)
                .environmentObject(container.sessionManager)
                .environmentObject(container.networkMonitor)
        }
    }
}
