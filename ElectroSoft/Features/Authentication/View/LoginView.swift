import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case email
        case password
    }
    
    init(container: AppDependencyContainer) {
        _viewModel = StateObject(wrappedValue: LoginViewModel(authRepo: container.authRepository))
    }
    
    var body: some View {
        ZStack {
            themeManager.currentTheme.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                VStack(spacing: 12) {
                    Text(StringConstants.appName)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(themeManager.currentTheme.text)
                    
                    Text(StringConstants.signInAccount)
                        .font(.subheadline)
                        .foregroundColor(themeManager.currentTheme.text.opacity(0.6))
                }
                .padding(.top, 50)
                
                Spacer()
                
                VStack(spacing: 24) {
                    emailField
                    passwordField
                    
                    loginButton
                        .padding(.top, 8)
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                VStack(spacing: 20) {
                    Text(StringConstants.customizeAppearance)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(themeManager.currentTheme.text.opacity(0.5))
                        .textCase(.uppercase)
                        .kerning(1.2)
                    
                    ThemeSelectorView()
                }
                .padding(.bottom, 20)
                .padding(.horizontal)
            }
        }
        .onChange(of: focusedField) { oldValue, newValue in
            if oldValue == .email { viewModel.emailTouched = true }
            if oldValue == .password { viewModel.passwordTouched = true }
        }
        .alert(isPresented: $viewModel.isAlertPresented) {
            Alert(
                title: Text(viewModel.alert?.title ?? StringConstants.error),
                message: Text(viewModel.alert?.message ?? ""),
                dismissButton: .default(Text(viewModel.alert?.primaryButtonTitle ?? StringConstants.ok))
            )
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onTapGesture {
            focusedField = nil
        }
    }
    
    private var emailField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(StringConstants.email)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(themeManager.currentTheme.text.opacity(0.7))
            
            TextField(StringConstants.enterEmail, text: $viewModel.email)
                .focused($focusedField, equals: .email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .submitLabel(.next)
                .onSubmit { focusedField = .password }
                .onChange(of: viewModel.email) { _,_ in viewModel.validateEmail() }
                .themedInput(
                    isFocused: focusedField == .email,
                    error: viewModel.emailError,
                    isTouched: viewModel.emailTouched
                )
            
            if viewModel.emailTouched, let error = viewModel.emailError {
                Text(error)
                    .foregroundColor(themeManager.currentTheme.error)
                    .font(.caption)
                    .transition(.opacity)
            }
        }
    }
    
    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(StringConstants.password)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(themeManager.currentTheme.text.opacity(0.7))
            
            HStack {
                if viewModel.showPassword {
                    TextField(StringConstants.enterPassword, text: $viewModel.password)
                        .focused($focusedField, equals: .password)
                } else {
                    SecureField(StringConstants.enterPassword, text: $viewModel.password)
                        .focused($focusedField, equals: .password)
                }
                
                Button(action: {
                    withAnimation { viewModel.showPassword.toggle() }
                }) {
                    Image(systemName: viewModel.showPassword ? "eye" : "eye.slash")
                        .foregroundStyle(themeManager.currentTheme.text.opacity(0.5))
                }
            }
            .themedInput(
                isFocused: focusedField == .password,
                error: viewModel.passwordError,
                isTouched: viewModel.passwordTouched
            )
            .onChange(of: viewModel.password) { _,_ in viewModel.validatePassword() }
            .submitLabel(.go)
            .onSubmit {
                Task { await viewModel.mockLogin() }
            }
            
            if viewModel.passwordTouched, let error = viewModel.passwordError {
                Text(error)
                    .foregroundColor(themeManager.currentTheme.error)
                    .font(.caption)
                    .transition(.opacity)
            }
        }
    }
    
    private var loginButton: some View {
        Button {
            focusedField = nil
            Task { await viewModel.mockLogin() }
        } label: {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(StringConstants.login)
                        .fontWeight(.bold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .background(
            (viewModel.isFormValid && !viewModel.isLoading)
            ? themeManager.currentTheme.primary
            : Color.gray.opacity(0.3)
        )
        .foregroundColor(.white)
        .cornerRadius(12)
        .disabled(!viewModel.isFormValid || viewModel.isLoading)
        .shadow(
            color: (viewModel.isFormValid && !viewModel.isLoading) ? themeManager.currentTheme.primary.opacity(0.4) : Color.clear,
            radius: 8, x: 0, y: 4
        )
        .scaleEffect(viewModel.isLoading ? 0.98 : 1.0)
        .animation(.spring(), value: viewModel.isLoading)
    }
}

#Preview {
    LoginView(container: AppDependencyContainer())
        .environmentObject(ThemeManager())
}
