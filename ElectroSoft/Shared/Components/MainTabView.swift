import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject private var session: SessionManager
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    
    @State private var selectedTab: TabItem = .dashboard
    @State private var isProfileOpen = false
    
    let container: AppDependencyContainer
    private let tabBarHeight: CGFloat = 90
    
    init(container: AppDependencyContainer) {
        self.container = container
    }
    
    private var roleTabs: [TabItem] {
        TabResolver.resolveTabs(
            roles: session.roles,
            userType: session.userType ?? .unknown
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                selectedTab
                    .destination(container: container)
                
                if !roleTabs.contains(.fallback) {
                    FloatingTabBar(selected: $selectedTab, tabs: roleTabs)
                }
                
                if !networkMonitor.isConnected {
                    NoInternetView()
                        .padding(.bottom, tabBarHeight)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .navigationTitle(selectedTab.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: toggleProfile) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .foregroundStyle(themeManager.currentTheme.primary)
                            .frame(width: 32, height: 32)
                    }
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
        .overlay(alignment: .leading) {
            ZStack(alignment: .leading) {
                if isProfileOpen {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture(perform: closeProfile)
                        .transition(.opacity)
                }
                
                UserProfileView(isOpen: $isProfileOpen)
                    .frame(width: 300)
                    .offset(x: isProfileOpen ? 0 : -300)
                    .frame(maxHeight: .infinity)
                    .shadow(color: Color.black.opacity(0.2), radius: 5)
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isProfileOpen)
        }
        .onChange(of: session.roles, handleRoleChange)
        .sheet(isPresented: $session.needPasswordReset) {
            ResetPasswordView(session: _session)
                .environmentObject(themeManager)
                .environmentObject(session)
        }
    }
}


private extension MainTabView {
    func toggleProfile() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            isProfileOpen.toggle()
        }
    }
    
    func closeProfile() {
        withAnimation { isProfileOpen = false }
    }
    
}

enum TabResolver {
    
    static func resolveTabs(
        roles: [Roles],
        userType: UserType
    ) -> [TabItem] {
        
        switch userType {
        case .service:
            return resolveServiceTabs(roles)
        case .client:
            return resolveClientTabs(roles)
        case .customer:
            return resolveCustomerTabs(roles)
        default:
            return [.fallback]
        }
    }
    
    private static func resolveServiceTabs(_ roles: [Roles]) -> [TabItem] {
        if roles.containsAny(of: [.owner, .stateHead, .districtHead, .talukaHead]) {
            return [.dashboard, .addEmployee, .employee, .client]
        }
        if roles.containsAny(of: [.representative, .support, .worker]) {
            return [.dashboard, .client, .invoice, .plan]
        }
        return [.fallback]
    }
    
    private static func resolveClientTabs(_ roles: [Roles]) -> [TabItem] {
        if roles.containsAny(of: [.owner, .stateHead, .districtHead, .talukaHead, .support]) {
            return [.dashboard, .employee, .bill, .issues]
        }
        return [.fallback]
    }
    
    private static func resolveCustomerTabs(_ roles: [Roles]) -> [TabItem] {
        roles.contains(.customer) ? [.bill, .issues] : [.fallback]
    }
}

extension Array where Element == Roles {
    func containsAny(of roles: [Roles]) -> Bool {
        contains { roles.contains($0) }
    }
}

private extension MainTabView {
    func handleRoleChange(old: [Roles], new: [Roles]) {
        let updatedTabs = roleTabs
        if let first = updatedTabs.first {
            selectedTab = first
        }
    }
}

#Preview(body: {
    MainTabView(container: AppDependencyContainer())
        .environmentObject(SessionManager(keychain: KeyChainManager()))
        .environmentObject(NetworkMonitor())
        .environmentObject(ThemeManager())
})
