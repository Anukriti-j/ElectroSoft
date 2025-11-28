import Foundation

struct LoggerInterceptor {
    
    static func logRequest(_ request: URLRequest) {
        #if DEBUG
        print("\n REQUEST")
        
        if let method = request.httpMethod, let url = request.url?.absoluteString {
            print("[\(method)] \(url)")
        }
        
        if let headers = request.allHTTPHeaderFields {
            print("Headers:", redactHeaders(headers))
        }
        
        if let body = request.httpBody,
           let json = String(data: body, encoding: .utf8) {
            print("Body:", redactSensitiveJSON(json))
        } else {
            print("Body: <empty>")
        }
        #endif
    }
    
    static func logResponse(data: Data, response: URLResponse) {
        #if DEBUG
        print("\n RESPONSE ")
        
        if let http = response as? HTTPURLResponse {
            print("Status Code:", http.statusCode)
        }
        
        let body = String(data: data, encoding: .utf8) ?? "<Invalid Data>"
        print("Response Body:", redactSensitiveJSON(body))
        print("====================================================\n")
        #endif
    }
    
    private static func redactHeaders(_ headers: [String: String]) -> [String: String] {
        headers.reduce(into: [:]) { result, entry in
            let key = entry.key.lowercased()
            if key.contains("authorization") || key.contains("token") {
                result[entry.key] = "<redacted>"
            } else {
                result[entry.key] = entry.value
            }
        }
    }
    
    private static func redactSensitiveJSON(_ json: String) -> String {
        var redacted = json
        
        let sensitiveKeys = ["password", "token", "accessToken", "refreshToken"]
        
        for key in sensitiveKeys {
            redacted = redacted.replacingOccurrences(
                of: "\"\(key)\":\"[^\"]+\"",
                with: "\"\(key)\":\"<redacted>\"",
                options: .regularExpression
            )
        }
        return redacted
    }
}
