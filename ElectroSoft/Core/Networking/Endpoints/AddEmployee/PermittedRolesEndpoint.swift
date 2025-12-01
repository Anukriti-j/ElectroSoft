
import Foundation

enum PermittedRolesEndpoint {
    case premittedRoles
}

extension PermittedRolesEndpoint: Endpoint {
    var path: String {
        return "/permittedRoles"
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: [String : String] {
        [
            "Accept": "application/json"
        ]
    }
    
    var body: Data? {
        nil
    }
    
    var contentType: String? {
        nil
    }
    
    var requiresAuth: Bool {
        true
    }
}
