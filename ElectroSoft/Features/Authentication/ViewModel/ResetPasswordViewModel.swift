import Foundation
import SwiftUI 

@MainActor
final class ResetPasswordViewModel: ObservableObject {
    
    @Published var newPassword = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var session: SessionManager?
    
    init() {}
    
    func configure(with session: SessionManager) {
        self.session = session
    }
    
    func resetPassword() {
        errorMessage = nil
        
        guard !newPassword.isEmpty, !confirmPassword.isEmpty else {
            errorMessage =  ErrorMessages.allRequiredFields.errorDescription
            return
        }
        guard newPassword.count >= 8 else {
            errorMessage = ErrorMessages.invalidPassword.errorDescription
            return
        }
        guard newPassword == confirmPassword else {
            errorMessage = ErrorMessages.passwordMismatch.errorDescription
            return
        }
        
        isLoading = true
        
        Task {
            do {
                // make an API call here.
                try await Task.sleep(nanoseconds: 1_500_000_000)
                
                isLoading = false
                session?.didCompletePasswordReset()
                
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
}
