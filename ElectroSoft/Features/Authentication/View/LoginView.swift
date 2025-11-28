import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            Text("ElectroSoft")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(themeManager.colors.primary)
            
            Text("LOG IN")
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .padding()
            
            VStack(alignment: .leading, spacing: 8) {
                TextField(StringConstants.email, text: $viewModel.email)
                    .themedInput()
                    .onSubmit {
                        viewModel.emailTouched = true
                        viewModel.validate()
                    }
                    .onChange(of: viewModel.email) {
                        if viewModel.emailTouched { viewModel.validate() }
                    }
                
                if viewModel.emailTouched, let error = viewModel.emailError {
                    Text(error)
                        .foregroundStyle(themeManager.colors.error)
                        .font(.caption)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .trailing) {
                    if viewModel.showPassword {
                        TextField(StringConstants.password, text: $viewModel.password)
                            .themedInput()
                            .onSubmit {
                                viewModel.passwordTouched = true
                                viewModel.validate()
                            }
                            .onChange(of: viewModel.password) {
                                if viewModel.passwordTouched { viewModel.validate() }
                            }
                        
                    } else {
                        SecureField(StringConstants.password, text: $viewModel.password)
                            .themedInput()
                            .onSubmit {
                                viewModel.passwordTouched = true
                                viewModel.validate()
                            }
                            .onChange(of: viewModel.password) {
                                if viewModel.passwordTouched { viewModel.validate() }
                            }

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
                        .foregroundStyle(themeManager.colors.error)
                        .font(.caption)
                }
            }
            
            Button {
                viewModel.emailTouched = true
                    viewModel.passwordTouched = true
                    viewModel.validate()

                    if viewModel.isFormValid {
                        viewModel.login()
                    }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Login")
                        .foregroundColor(.white)
                }
            }
            .disabled(viewModel.isLoading)
            .themedButton(isDisabled: !viewModel.isFormValid)
        }
        .padding(.horizontal)
    }
}

#Preview {
    LoginView()
}
