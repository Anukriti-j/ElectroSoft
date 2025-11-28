import Foundation

final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    @Published var emailTouched = false
    @Published var passwordTouched = false
    
    @Published var showPassword = false
    @Published var isLoading = false
    
    @Published var emailError: String?
    @Published var passwordError: String?
    
    var isFormValid: Bool {
        emailError == nil && passwordError == nil
    }
    
    func login() {
        isLoading = true
        defer {
            isLoading = false
        }
        print("Login")
    }
}

extension LoginViewModel {
    func validate() {
        if emailTouched {
            if email.isEmpty {
                emailError = ErrorMessages.requiredEmail
            } else if !FormValidator.isValidEmail(email) {
                emailError = ErrorMessages.invalidEmail
            } else {
                emailError = nil
            }
        }
        
        if passwordTouched {
            if password.isEmpty {
                passwordError = ErrorMessages.requiredPassword
            } else {
                passwordError = nil
            }
        }
    }
}
