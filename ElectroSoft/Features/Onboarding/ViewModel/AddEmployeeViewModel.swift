import Foundation

@MainActor
final class AddEmployeeViewModel: ObservableObject {
    
    @Published var name = ""
    @Published var email = ""
    @Published var phoneNumber = ""
    
    @Published var nameError: String?
    @Published var emailError: String?
    @Published var phoneError: String?
    
    @Published var roles: [CreateRoles] = []
    @Published var states: [States] = []
    @Published var districts: [District] = []
    @Published var cities: [City] = []
    
    @Published var stateId: Int?
    @Published var districtId: Int?
    @Published var cityId: Int?
    @Published var roleId: Int?
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var didSubmitForm = false
    
    private let locationRepo: LocationRepository
    private let addEmployeeRepo: AddEmployeeRepositoryProtocol
    
    init(locationRepo: LocationRepository, addEmployeeRepo: AddEmployeeRepositoryProtocol) {
        self.locationRepo = locationRepo
        self.addEmployeeRepo = addEmployeeRepo
    }
    
    func loadInitialData(session: SessionManager) async {
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        isLoading = true
        defer { isLoading = false }
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.loadRoles(session: session) }
            group.addTask { await self.fetchStates() }
        }
    }
    
    func loadRoles(session: SessionManager) async {
        do {
            let fetchedRoles = try await addEmployeeRepo.loadPermittedRoles()
            self.roles = fetchedRoles
        } catch {
            self.errorMessage = "Failed to load roles"
        }
    }
    
    func fetchStates() async {
        do {
            let fetchedStates = try await locationRepo.getStates()
            self.states = fetchedStates
        } catch {
            self.errorMessage = "Failed to load states"
        }
    }
    
    func fetchDistricts() async {
        guard let stateId = stateId else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let fetchedDistricts = try await locationRepo.getDistricts(stateId: stateId)
            self.districts = fetchedDistricts
            
            self.districtId = nil
            self.cityId = nil
            self.cities = []
        } catch {
            self.errorMessage = "Failed to load districts"
        }
    }
    
    func fetchCities() async {
        guard let districtId = districtId else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let fetchedCities = try await locationRepo.getCities(districtId: districtId)
            self.cities = fetchedCities
            
            self.cityId = nil
        } catch {
            self.errorMessage = "Failed to load cities"
        }
    }
    
    func addEmployee() async {
        runFullValidation()
        
        guard isFormValid else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        print("Employee submitted successfully")
        didSubmitForm = true
        resetForm()
    }
}

extension AddEmployeeViewModel {
    
    var isFormEmpty: Bool {
        name.isEmpty && email.isEmpty && phoneNumber.isEmpty &&
        roleId == nil && stateId == nil && districtId == nil && cityId == nil
    }
    
    func validateName() {
        var newError: String? = nil
        do {
            try FormValidator.validateName(name)
        } catch let error {
            newError = error.localizedDescription
        }
        
        if nameError != newError {
            DispatchQueue.main.async {
                self.nameError = newError
            }
        }
    }
    
    func validateEmail() {
        var newError: String? = nil
        do {
            try FormValidator.validateEmail(email)
        } catch let error {
            newError = error.localizedDescription
        }
        
        if emailError != newError {
            DispatchQueue.main.async {
                self.emailError = newError
            }
        }
    }
    
    func validatePhone() {
        var newError: String? = nil
        do {
            try FormValidator.validatePhone(phoneNumber)
        } catch let error {
            newError = error.localizedDescription
        }
        
        if phoneError != newError {
            DispatchQueue.main.async {
                self.phoneError = newError
            }
        }
    }
    
    private func runFullValidation() {
        do { try FormValidator.validateName(name); nameError = nil }
        catch let error { nameError = error.localizedDescription }
        
        do { try FormValidator.validateEmail(email); emailError = nil }
        catch let error { emailError = error.localizedDescription }
        
        do { try FormValidator.validatePhone(phoneNumber); phoneError = nil }
        catch let error { phoneError = error.localizedDescription }
    }
    
    var isFormValid: Bool {
        guard !name.isEmpty, !email.isEmpty, !phoneNumber.isEmpty else { return false }
        
        if nameError != nil || emailError != nil || phoneError != nil { return false }
        
        return roleId != nil && stateId != nil && districtId != nil && cityId != nil
    }
    
    func resetForm() {
        guard !isLoading else { return }
        
        name = ""
        email = ""
        phoneNumber = ""
        roleId = nil
        stateId = nil
        districtId = nil
        cityId = nil
        
        nameError = nil
        emailError = nil
        phoneError = nil
        
        didSubmitForm = false
    }
}

extension AddEmployeeViewModel {
    
    func shouldShowStatePicker(userRoles: [Roles]) -> Bool {
        !userRoles.contains(.talukaHead) && !userRoles.contains(.stateHead) && !userRoles.contains(.districtHead)
    }
    
    func shouldShowDistrictPicker(userRoles: [Roles]) -> Bool {
        userRoles.contains(.stateHead) || userRoles.contains(.districtHead) || userRoles.contains(.clientHead)
    }
    
    func shouldShowCityPicker(userRoles: [Roles]) -> Bool {
        userRoles.contains(.districtHead) || userRoles.contains(.talukaHead) || userRoles.contains(.support) || userRoles.contains(.worker)
    }
}
