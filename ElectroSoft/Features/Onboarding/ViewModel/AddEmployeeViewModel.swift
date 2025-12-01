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
    private let addEmployeeRepo: AddEmployeeRepository
    
    init(locationRepo: LocationRepository, addEmployeeRepo: AddEmployeeRepository) {
        self.locationRepo = locationRepo
        self.addEmployeeRepo = addEmployeeRepo
    }
    
    func loadInitialData(session: SessionManager) async {
        await loadRoles(session: session)
        await fetchStates()
    }
    
    func loadRoles(session: SessionManager) async {
        guard !session.roles.isEmpty else { return }
        do {
            self.roles = try await addEmployeeRepo.loadPermittedRoles()
        } catch {
            errorMessage = "error"
        }
       
    }
    
    func fetchStates() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.states = try await locationRepo.getStates()
        } catch {
            errorMessage = "Failed to load states"
        }
    }
    
    func fetchDistricts() async {
        guard let stateId else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.districts = try await locationRepo.getDistricts(stateId: stateId)
        } catch {
            errorMessage = "Failed to load districts"
        }
    }
    
    func fetchCities() async {
        guard let districtId else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.cities = try await locationRepo.getCities(districtId: districtId)
        } catch {
            errorMessage = "Failed to load cities"
        }
    }
   
    func addEmployee() async {
        guard isFormValid() else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        print("Employee submitted!")
        
        didSubmitForm = true
        resetForm()
    }
}

extension AddEmployeeViewModel {
    
    var isFormEmpty: Bool {
        name.isEmpty &&
        email.isEmpty &&
        phoneNumber.isEmpty &&
        roleId == nil &&
        stateId == nil &&
        districtId == nil &&
        cityId == nil
    }
    
    func validateName() {
        do {
            try FormValidator.validateName(name)
            nameError = nil
        } catch {
            nameError = error.localizedDescription
        }
    }
    
    func validateEmail() {
        do {
            try FormValidator.validateEmail(email)
            emailError = nil
        } catch {
            emailError = error.localizedDescription
        }
    }
    
    func validatePhone() {
        do {
            try FormValidator.validatePhone(phoneNumber)
            phoneError = nil
        } catch {
            phoneError = error.localizedDescription
        }
    }
    
    func isFormValid() -> Bool {
        validateName()
        validateEmail()
        validatePhone()
        
        return nameError == nil &&
               emailError == nil &&
               phoneError == nil &&
               roleId != nil &&
               stateId != nil &&
               districtId != nil &&
               cityId != nil
    }
    
    func resetForm() {
        guard didSubmitForm else { return }
        guard !isFormEmpty else { return }
        
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
