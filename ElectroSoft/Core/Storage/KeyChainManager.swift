import Security
import Foundation

enum KeychainKey {
    case accessToken
    case refreshToken
    
    var raw: String {
        switch self {
        case .accessToken: return "access_token"
        case .refreshToken: return "refresh_token"
        }
    }
}

protocol KeyChainManaging {
    func save(_ key: KeychainKey, value: String)
    func read(_ key: KeychainKey) -> String?
    func delete(_ key: KeychainKey)
}

final class KeyChainManager: KeyChainManaging {
    
    private let queue = DispatchQueue(label: "com.electrosoft.keychain", attributes: .concurrent)
    
    func save(_ key: KeychainKey, value: String) {
        // Barrier: Stops all other reads/writes while this executes
        queue.async(flags: .barrier) {
            self._delete(key)
            self._save(key, value: value)
        }
    }
    
    func read(_ key: KeychainKey) -> String? {
        queue.sync {
            self._read(key)
        }
    }
    
    func delete(_ key: KeychainKey) {
        queue.async(flags: .barrier) {
            self._delete(key)
        }
    }
    
    private func _save(_ key: KeychainKey, value: String) {
        guard let data = value.data(using: .utf8) else { return }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.raw,
            kSecValueData as String: data
        ]
        
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func _read(_ key: KeychainKey) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.raw,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess, let data = item as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    private func _delete(_ key: KeychainKey) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.raw
        ]
        SecItemDelete(query as CFDictionary)
    }
}
