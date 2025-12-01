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

import Security
import Foundation

final class KeyChainManager: KeyChainManaging {
    private let queue = DispatchQueue(label: "secure.keychain.queue")

    func save(_ key: KeychainKey, value: String) {
        queue.sync {
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
        queue.sync {
            self._delete(key)
        }
    }

    private func _save(_ key: KeychainKey, value: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.raw,
            kSecValueData as String: value.data(using: .utf8)!
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
        SecItemCopyMatching(query as CFDictionary, &item)

        guard let data = item as? Data else { return nil }
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
