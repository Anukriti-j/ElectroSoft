import Foundation

enum LocationEndpoints {
    case getStates
    case getDistricts(stateId: Int)
    case getCities(districtId: Int)
}

extension LocationEndpoints: Endpoint {
    
    var path: String {
        switch self {
        case .getStates:
            return "/location/states"
            
        case .getDistricts(let stateId):
            return "/location/districts?stateId=\(stateId)"
            
        case .getCities(let districtId):
            return "/location/cities?districtId=\(districtId)"
        }
    }
    
    var method: HTTPMethod {
        .GET
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
