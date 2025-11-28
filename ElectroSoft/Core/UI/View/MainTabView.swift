import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var session: SessionManager
    @State private var selectedTab: TabItem = .dashboard
    @State private var isProfileOpen = false

    var body: some View {
        let roleTabs = tabs(for: session.userRole)
        
        ZStack(alignment: .leading) {
            ZStack(alignment: .bottom) {
                NavigationStack {
                    selectedTab.destination
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

    func tabs(for role: UserRole) -> [TabItem] {
        switch role {
        case .ServiceOwner, .ServiceStateHead, .ServiceDistrictHead, .ServiceCityHead:
            return [.dashboard, .addEmployee, .employee, .client]
        case .Representative, .ServiceSupport, .Worker:
            return [.dashboard, .client, .invoice, .plan]
        case .ClientIndianHead, .ClientStateHead, .ClientDistrictHead, .ClientCityHead, .ClientSupport:
            return [.dashboard, .employee, .issues, .bill]
        case .Customer:
            return [.bill, .issues]
        case .unknown:
            return [.fallback]
        }
    }
}
