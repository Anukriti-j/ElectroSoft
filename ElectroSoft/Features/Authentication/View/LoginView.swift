import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    init(authRepo: AuthRepository) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(authRepo: authRepo))
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text("ElectroSoft")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(themeManager.colors.primary)
            
            Text("LOG IN")
                .font(.title2.bold())
                .padding(.bottom, 8)
            
            VStack(alignment: .leading, spacing: 8) {
                TextField("Email", text: $viewModel.email)
                    .themedInput()
                    .onTapGesture {
                        viewModel.emailTouched = true
                    }
                    .onChange(of: viewModel.email) { _ in
                        viewModel.validateEmail()
                    }
                
                if viewModel.emailTouched, let error = viewModel.emailError {
                    Text(error)
                        .foregroundColor(themeManager.colors.error)
                        .font(.caption)
                }
            }
           
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .trailing) {
                    
                    Group {
                        if viewModel.showPassword {
                            TextField("Password", text: $viewModel.password)
                        } else {
                            SecureField("Password", text: $viewModel.password)
                        }
                    }
                    .themedInput()
                    .onTapGesture {
                        viewModel.passwordTouched = true
                    }
                    .onChange(of: viewModel.password) { _ in
                        viewModel.validatePassword()
                    }
                    
                    Button(action: {
                        viewModel.showPassword.toggle()
                    }) {
                        Image(systemName: viewModel.showPassword ? "eye" : "eye.slash")
                            .foregroundStyle(.gray)
                    }
                    .padding(.trailing, 12)
                }
                
                if viewModel.passwordTouched, let error = viewModel.passwordError {
                    Text(error)
                        .foregroundColor(themeManager.colors.error)
                        .font(.caption)
                }
            }
            
            Button {
                Task { await viewModel.login() }
            } label: {
                if viewModel.isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text("Login")
                        .foregroundColor(.white)
                }
            }
            .disabled(!viewModel.isFormValid || viewModel.isLoading)
            .themedButton(isDisabled: !viewModel.isFormValid || viewModel.isLoading)
            
            
        }
        .padding(.horizontal)
        .alert(isPresented: $viewModel.isAlertPresented) {
            Alert(
                title: Text(viewModel.alert?.title ?? ""),
                message: Text(viewModel.alert?.message ?? ""),
                dismissButton: .default(Text(viewModel.alert?.primaryButtonTitle ?? "OK"))
            )
        }
    }
}

#Preview {
    LoginView(
        authRepo: AuthRepository(
            api: APIClient(keychain: KeyChainManager()),
            session: SessionManager(keychain: KeyChainManager())
        )
    )
}
