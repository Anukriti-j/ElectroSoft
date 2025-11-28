import Foundation

final class AddEmployeeViewModel: ObservableObject {
    var name = ""
    var email = ""
    var phoneNumber = ""
    var role: UserRole = .unknown
    var states = [
        "Madhyapradesh",
        "maharasthra",
        "Tamil Nadu",
        "Karnataka"
    ]    
}
