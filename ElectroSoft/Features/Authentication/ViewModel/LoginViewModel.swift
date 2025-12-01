import Foundation
import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = "" 
    
    @Published var emailTouched = false
    @Published var passwordTouched = false
    
    @Published var showPassword = false
    @Published var isLoading = false
    
    @Published var emailError: String?
    @Published var passwordError: String?
    
    @Published var alert: AppAlert?
    @Published var isAlertPresented = false
    
    private let authRepo: AuthRepository
    
    init(authRepo: AuthRepository) {
        self.authRepo = authRepo
    }
    
    var isFormValid: Bool {
        emailError == nil && passwordError == nil
    }
    
    func validateEmail() {
        guard emailTouched else { return }
        do {
            try FormValidator.validateEmail(email)
            emailError = nil
        } catch {
            emailError = error.localizedDescription
        }
    }
    
    func validatePassword() {
        guard passwordTouched else { return }
        do {
            try FormValidator.notEmptyField(password)
            passwordError = nil
        } catch {
            passwordError = error.localizedDescription
        }
    }
    
    func login() async {
        emailTouched = true
        passwordTouched = true
        
        validateEmail()
        validatePassword()
        
        guard isFormValid else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let response = try await authRepo.login(email: email, password: password)
            alert = AppAlert.simple(
                title: "Login Success",
                message: "Welcome, \(response.userDetails.name)!"
            )
            isAlertPresented = true
        } catch {
            alert = AppAlert.simple(
                title: "Login Failed",
                message: error.localizedDescription
            )
            isAlertPresented = true
        }
    }
}
