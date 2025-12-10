import SwiftUI

@MainActor
final class SessionManager: ObservableObject {
    
    @Published var isLoggedIn = false
    @Published var user: UserDetails?
    @Published var userType: UserType?
    @Published var roles: [Roles] = []
    @Published var needPasswordReset = false
    
    private let keychain: KeyChainManaging
    
    init(keychain: KeyChainManaging) {
        self.keychain = keychain
        
        self.userType = .service
        self.roles = [.owner]
        self.user = UserDetails(
            id: "999",
            name: "Developer",
            contactNo: "1234567890",
            userType: "service",
            roles: ["Owner"]
        )
        self.isLoggedIn = false
        self.needPasswordReset = true
    }
    
    func restoreSession() {
        DispatchQueue.main.async { [weak self] in
            self?.setupMockSession()
        }
    }
    
    private func setupMockSession() {
        self.userType = .service
        self.roles = [.owner]
        self.user = UserDetails(
            id: "999",
            name: "Developer",
            contactNo: "1234567890",
            userType: "service",
            roles: ["Owner"]
        )
//        withAnimation {
//            self.isLoggedIn = true
//        }
    }
    
    func setUpUserSession(user: UserDetails) {
        self.userType = .service
        self.roles = [.owner]
        self.user = user
        withAnimation {
            self.isLoggedIn = true
           // self.needPasswordReset = needReset field from API to resetPassword or not
        }
    }
    
    func didCompletePasswordReset() {
        self.needPasswordReset = false
    }
    
    func saveToken(accessToken: String, refreshToken: String) {
        keychain.save(.accessToken, value: accessToken)
        keychain.save(.refreshToken, value: refreshToken)
    }
    
    func logout() {
        keychain.delete(.accessToken)
        keychain.delete(.refreshToken)
        
        withAnimation {
            user = nil
            roles = []
            userType = nil
            isLoggedIn = false
            needPasswordReset = false
        }
    }
}

extension SessionManager {
    var isServiceUser: Bool { userType == .service }
    var isClientUser: Bool { userType == .client }
    var isCustomer: Bool { userType == .customer }
    
    func hasRole(_ role: Roles) -> Bool {
        roles.contains(role)
    }
}
