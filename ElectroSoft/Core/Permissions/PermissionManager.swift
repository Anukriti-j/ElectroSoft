//import Foundation
//
//struct PermissionManager {
//
//    static func allowedRolesToCreate(userType: UserType, currentRole: Roles) -> [Roles] {
//        switch userType {
//        case .service:
//            switch currentRole {
//            case .owner:
//                return [.stateHead, .districtHead, .talukaHead, .representative]
//            case .stateHead:
//                return [.districtHead, .talukaHead, .representative]
//            case .districtHead:
//                return [.talukaHead, .support]
//            case .talukaHead:
//                return [.support, .worker]
//            case .support:
//                return [.customer]
//            default:
//                return []
//            }
//        case .client:
//            switch currentRole {
//            case .clientHead:
//                return [.stateHead, .districtHead, .talukaHead]
//            case .stateHead:
//                return [.districtHead, .talukaHead]
//            case .districtHead:
//                return [.talukaHead]
//            case .talukaHead:
//                return [.support]
//            default:
//                return []
//            }
//        case .customer, .unknown:
//            return []
//        }
//    }
//
//    // Merge permissions for multiple roles
//    static func allowedRolesToCreate(userType: UserType, currentRoles: [Roles]) -> [Roles] {
//        var allAllowed: [Roles] = []
//
//        for role in currentRoles {
//            let allowed = allowedRolesToCreate(userType: userType, currentRole: role)
//            allAllowed.append(contentsOf: allowed)
//        }
//
//        return Array(Set(allAllowed))
//    }
//}
