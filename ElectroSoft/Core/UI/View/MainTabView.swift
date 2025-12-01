import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var session: SessionManager
    @EnvironmentObject var themeManager: ThemeManager
    @State var selectedTab: TabItem = .dashboard
    @State var isProfileOpen = false
    let locationRepo: LocationRepository
    let addEmployeeRepo: AddEmployeeRepository
    
    var body: some View {
        let roleTabs = tabs(forRole: session.roles,forType: session.userType ?? .unknown)
        
        ZStack(alignment: .leading) {
            ZStack(alignment: .bottom) {
                NavigationStack {
                    selectedTab
                        .destination(locationRepo: locationRepo, addEmployeeRepo: addEmployeeRepo)
                        .navigationTitle(selectedTab.title)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        isProfileOpen.toggle()
                                    }
                                } label: {
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .foregroundStyle(themeManager.colors.primary)
                                        .frame(width: 42, height: 42)
                                }
                            }
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.keyboard)
                
                FloatingTabBar(selected: $selectedTab, tabs: roleTabs)
                    .padding(.horizontal, 4)
                    .padding(.bottom, 0)
            }
            .ignoresSafeArea(.all, edges: .bottom)
            
            if isProfileOpen {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isProfileOpen = false
                        }
                    }
            }
            
            UserProfileView(isOpen: $isProfileOpen)
                .frame(width: 300)
                .frame(maxHeight: .infinity)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
                .offset(x: isProfileOpen ? 0 : -300)
                .transition(.move(edge: .leading))
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isProfileOpen)
        }
        .onAppear {
            selectedTab = roleTabs.first ?? .dashboard
        }
    }
    
    func tabs(forRole roles: [Roles], forType type: UserType) -> [TabItem] {
        if type == .service {
            if roles.contains(.owner) ||
                roles.contains(.stateHead) ||
                roles.contains(.districtHead) ||
                roles.contains(.talukaHead) {
                return [.dashboard, .addEmployee, .employee, .client]
            }
            
            if roles.contains(.representative) ||
                roles.contains(.support) ||
                roles.contains(.worker) {
                return [.dashboard, .client, .invoice, .plan]
            }
        } else if type == .client {
            if roles.contains(.owner) ||
                roles.contains(.stateHead) ||
                roles.contains(.districtHead) ||
                roles.contains(.talukaHead) ||
                roles.contains(.support) {
                return [.dashboard, .employee, .bill, .issues]
            }
        } else if type == .customer {
            if roles.contains(.customer) {
                return [.bill, .issues]
            }
        }
        
        
        return [.fallback]
    }
}
