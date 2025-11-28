import SwiftUI

//enum AppEntryScreen {
//    case dashboard
//    case task
//}

final class SessionManager: ObservableObject {

    private let keychain: KeyChainManager
    private let authRepo: AuthRepository

    @Published var isLoggedIn = true
    @Published var user: LoginData?
   // var landingScreen: AppEntryScreen?
    @Published var userRole: UserRole = .ServiceOwner

    init(keychain: KeyChainManager, authRepo: AuthRepository) {
        self.keychain = keychain
        self.authRepo = authRepo
    }

    func restoreSession() {
        if keychain.read(.accessToken) != nil {
            isLoggedIn = true
        }
    }

    func login(email: String, password: String) async {
        do {
            let userData = try await authRepo.login(email: email, password: password)

            keychain.save(.accessToken, value: userData.accessToken)
            keychain.save(.refreshToken, value: userData.refreshToken)
            self.userRole = .ServiceOwner
            self.user = userData
            self.isLoggedIn = true

        } catch {
            print("Login Error:", error.localizedDescription)
        }
    }

    func logout() {
        keychain.delete(.accessToken)
        keychain.delete(.refreshToken)
        user = nil
        isLoggedIn = false
    }
}
