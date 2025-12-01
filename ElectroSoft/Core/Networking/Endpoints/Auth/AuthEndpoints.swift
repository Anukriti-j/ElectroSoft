import Foundation

enum AuthEndpoints {
    case login(email: String, password: String)
    case refreshToken(_ refreshToken: String)
}

extension AuthEndpoints: Endpoint {
    
    var path: String {
        switch self {
        case .login:
            return "/auth/sign-in"
        case .refreshToken:
            return "/auth/refresh-token"
        }
    }
    
    var method: HTTPMethod {
        .POST
    }
    
    var headers: [String : String] {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
    
    var body: Data? {
        switch self {
        case .login(let email, let password):
            return try? JSONEncoder().encode([
                "email": email,
                "password": password
            ])
            
        case .refreshToken(let token):
            return try? JSONEncoder().encode([
                "refresh_token": token
            ])
        }
    }
    
    var contentType: String? {
        "application/json"
    }
    
    var requiresAuth: Bool {
        switch self {
        case .login, .refreshToken:
            return false
        }
    }
}
