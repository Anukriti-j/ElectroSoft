import Foundation

enum UserRole: String, Codable {
    case ServiceOwner = "ServiceOwner"
    case ServiceStateHead = "ServiceStateHead"
    case ServiceDistrictHead = "ServiceDistrictHead"
    case ServiceCityHead = "ServiceCityHead"
    case Representative = "Representative"
    case ServiceSupport = "ServiceSupport"
    case Worker = "Worker"
    case ClientIndianHead = "ClientIndianHead"
    case ClientStateHead = "ClientStateHead"
    case ClientDistrictHead = "ClientDistrictHead"
    case ClientCityHead = "ClientCityHead"
    case ClientSupport = "ClientSupport"
    case Customer = "Customer"
    case unknown = "Unknown"
}
