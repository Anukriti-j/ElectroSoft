import SwiftUI

struct AddEmployeeView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var session: SessionManager
    
    @StateObject private var viewModel: AddEmployeeViewModel
    
    init(container: AppDependencyContainer) {
        _viewModel = StateObject(wrappedValue:
                                    AddEmployeeViewModel(locationRepo: container.locationRepository, addEmployeeRepo: container.addEmployeeRepository)
        )
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                Section(header: Text("Personal Info")) {
                    TextField("Name", text: $viewModel.name)
                        .onChange(of: viewModel.name) { _,_ in viewModel.validateName() }
                    
                    if let error = viewModel.nameError {
                        Text(error).foregroundStyle(.red).font(.caption)
                    }
                    
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .onChange(of: viewModel.email) { _,_ in viewModel.validateEmail() }
                    
                    if let error = viewModel.emailError {
                        Text(error).foregroundStyle(.red).font(.caption)
                    }
                    
                    TextField("Phone Number", text: $viewModel.phoneNumber)
                        .keyboardType(.numberPad)
                        .onChange(of: viewModel.phoneNumber) { _,_ in viewModel.validatePhone() }
                    
                    if let error = viewModel.phoneError {
                        Text(error).foregroundStyle(.red).font(.caption)
                    }
                }
                
                Section(header: Text("Role")) {
                    Picker("Select Role", selection: $viewModel.roleId) {
                        Text("Select").tag(nil as Int?)
                        ForEach(viewModel.roles) { role in
                            Text(role.createRoleName).tag(role.id as Int?)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section(header: Text("Work Location")) {
                    Picker("Select State", selection: $viewModel.stateId) {
                        Text("Select").tag(nil as Int?)
                        ForEach(viewModel.states) { state in
                            Text(state.stateName).tag(state.id as Int?)
                        }
                    }
                    .onChange(of: viewModel.stateId) { _,_ in
                        Task { await viewModel.fetchDistricts() }
                    }
                    
                    if !viewModel.districts.isEmpty {
                        Picker("Select District", selection: $viewModel.districtId) {
                            Text("Select").tag(nil as Int?)
                            ForEach(viewModel.districts) { district in
                                Text(district.districtName).tag(district.id as Int?)
                            }
                        }
                        .onChange(of: viewModel.districtId) { _,_ in
                            Task { await viewModel.fetchCities() }
                        }
                    }
                    
                    if !viewModel.cities.isEmpty {
                        Picker("Select City", selection: $viewModel.cityId) {
                            Text("Select").tag(nil as Int?)
                            ForEach(viewModel.cities) { city in
                                Text(city.cityName).tag(city.id as Int?)
                            }
                        }
                    }
                }
                
                HStack(spacing: 20) {
                    Button("Reset") {
                        withAnimation { viewModel.resetForm() }
                    }
                    .themedButton()
                    
                    Button("Save") {
                        Task { await viewModel.addEmployee() }
                    }
                    .themedButton(isDisabled: !viewModel.isFormValid || viewModel.isLoading)
                }
                .listRowBackground(Color.clear)
                .padding(.top, 10)
            }
        }
        .onAppear {
            Task { await viewModel.loadInitialData(session: session) }
        }
        .navigationTitle("Add Employee")
    }
}

#if DEBUG
#Preview {
    let container = AppDependencyContainer()
    AddEmployeeView(
        container: AppDependencyContainer()
    )
    .environmentObject(container.themeManager)
    .environmentObject(container.sessionManager)
}
#endif
