import SwiftUI

struct AddEmployeeView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var session: SessionManager
    
    @StateObject private var viewModel: AddEmployeeViewModel
    
    init(locationRepo: LocationRepository, addEmployeeRepo: AddEmployeeRepository) {
        _viewModel = StateObject(wrappedValue:
                                    AddEmployeeViewModel(locationRepo: locationRepo, addEmployeeRepo: addEmployeeRepo)
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                
                Section(header: Text("Personal Info")) {
                    
                    TextField("Name", text: $viewModel.name)
                    if let error = viewModel.nameError {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                    
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                    if let error = viewModel.emailError {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                    
                    TextField("Phone Number", text: $viewModel.phoneNumber)
                        .keyboardType(.numberPad)
                    if let error = viewModel.phoneError {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
                
                Section(header: Text("Role")) {
                    Picker("Select Role", selection: $viewModel.roleId) {
                        ForEach(viewModel.roles) { role in
                            Text(role.createRoleName).tag(role.id)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section(header: Text("Work Location")) {
                    
                    Picker("Select State", selection: $viewModel.stateId) {
                        ForEach(viewModel.states) { state in
                            Text(state.stateName).tag(state.id)
                        }
                    }
                    
                    Picker("Select District", selection: $viewModel.districtId) {
                        ForEach(viewModel.districts) { district in
                            Text(district.districtName).tag(district.id)
                        }
                    }
                    
                    Picker("Select City", selection: $viewModel.cityId) {
                        ForEach(viewModel.cities) { city in
                            Text(city.cityName).tag(city.id)
                        }
                    }
                }
                
                HStack {
                    Button("Reset") {
                        viewModel.resetForm()
                    }
                    .themedButton()
                    
                    Button("Save") {
                        Task { await viewModel.addEmployee() }
                    }
                    .themedButton(isDisabled: !viewModel.isFormValid() || viewModel.isLoading)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.loadInitialData(session: session)
            }
        }
    }
}

#Preview {
    AddEmployeeView(locationRepo: LocationRepository(api: APIClient(keychain: KeyChainManager())), addEmployeeRepo: AddEmployeeRepository(apiClient: APIClient(keychain: KeyChainManager())))
        .environmentObject(ThemeManager())
        .environmentObject(SessionManager(keychain: KeyChainManager()))
}
