import Foundation

final class FormValidator {
    
    static func validateName(_ name: String) throws {
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            throw ErrorMessages.emptyName
        }
    }
    
    static func notEmptyField(_ field: String) throws {
        if field.trimmingCharacters(in: .whitespaces).isEmpty {
            throw ErrorMessages.requiredField
        }
    }
    
    static func validateEmail(_ email: String) throws {
        if email.isEmpty {
            throw ErrorMessages.requiredEmail
        }
        let regex = #"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$"#
        let isValid = NSPredicate(format: "SELF MATCHES[c] %@", regex)
            .evaluate(with: email)
        
        if !isValid { throw ErrorMessages.invalidEmail }
    }
    
    static func validatePhone(_ phone: String) throws {
        if phone.isEmpty {
            throw ErrorMessages.requiredPhone
        }
        let regex = #"^[0-9]{10}$"#
        let isValid = NSPredicate(format: "SELF MATCHES %@", regex)
            .evaluate(with: phone)
        
        if !isValid { throw ErrorMessages.invalidPhone }
    }
}
