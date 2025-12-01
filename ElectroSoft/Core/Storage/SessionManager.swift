import SwiftUI

@MainActor
final class SessionManager: ObservableObject {
    
    @Published var isLoggedIn = false
    @Published var user: UserDetails?
    @Published var userType: UserType?
    @Published var roles: [Roles] = []
    private let keychain: KeyChainManager
    
    init(keychain: KeyChainManager) {
        self.keychain = keychain
    }
    
    func restoreSession() {
        if keychain.read(.accessToken) != nil {
            isLoggedIn = true
        }
    }
   
    func setUpUserSession(user: UserDetails) {
        self.isLoggedIn = true
        self.user = UserDetails(
            id: user.id,
            name: user.name,
            contactNo: user.contactNo,
            userType: user.userType,
            roles: user.roles
        )
        self.userType = UserType(rawValue: user.userType)
        //self.roles = user.roles.map { $0 }
    }
    
    func saveToken(accessToken: String, refreshToken: String) {
        keychain.save(.accessToken, value: accessToken)
        keychain.save(.refreshToken, value: refreshToken)
    }
    
    func logout() {
        keychain.delete(.accessToken)
        keychain.delete(.refreshToken)
        user = nil
        roles = []
        userType = nil
        isLoggedIn = false
    }
}

extension SessionManager {
    
    var isServiceUser: Bool {
        userType == .service
    }
    
    var isClientUser: Bool {
        userType == .client
    }
    
    var isCustomer: Bool {
        userType == .customer
    }
    
    func hasRole(_ role: Roles) -> Bool {
        roles.contains(role)
    }
}
