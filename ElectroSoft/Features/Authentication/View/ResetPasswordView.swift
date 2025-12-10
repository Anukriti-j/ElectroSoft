import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var session: SessionManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @StateObject private var viewModel = ResetPasswordViewModel()
    @FocusState var focusedfield: Field?
    
    enum Field {
        case newPassword
        case confirmPassword
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "key.fill")
                .font(.system(size: 50))
                .foregroundColor(themeManager.currentTheme.primary)
            
            Text(StringConstants.resetPassword)
                .font(.largeTitle.bold())
            
            Text(StringConstants.securityTitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 15) {
                SecureField(StringConstants.newPassword, text: $viewModel.newPassword)
                    .focused($focusedfield, equals: .newPassword)
                    .submitLabel(.next)
                    .themedInput(
                        isFocused: focusedfield == .newPassword,
                    )
                
                SecureField(StringConstants.confirmPassword, text: $viewModel.confirmPassword)
                    .focused($focusedfield, equals: .confirmPassword)
                    .submitLabel(.go)
                    .onSubmit(viewModel.resetPassword)
                    .themedInput(
                        isFocused: focusedfield == .confirmPassword,
                    )
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(themeManager.currentTheme.error)
                    .transition(.opacity)
            }
            
            Button(action: { viewModel.resetPassword() }) {
                if viewModel.isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text(StringConstants.save)
                }
            }
            .themedButton(isDisabled: viewModel.newPassword.isEmpty || viewModel.confirmPassword.isEmpty || viewModel.isLoading)
        }
        .padding()
        .animation(.easeInOut, value: viewModel.errorMessage)
        .interactiveDismissDisabled()
        .onAppear {
            viewModel.configure(with: session)
        }
    }
}


#if DEBUG
#Preview {
    let session = SessionManager(keychain: KeyChainManager())
    
    ResetPasswordView()
        .environmentObject(session)
        .environmentObject(ThemeManager())
}
#endif
