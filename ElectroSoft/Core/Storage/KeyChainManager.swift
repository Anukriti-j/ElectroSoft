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
    private let queue = DispatchQueue(label: "secure.keychain.queue")

    func save(_ key: KeychainKey, value: String) {
        queue.sync {
            delete(key)

            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key.raw,
                kSecValueData as String: value.data(using: .utf8)!
            ]

            SecItemAdd(query as CFDictionary, nil)
        }
    }

    func read(_ key: KeychainKey) -> String? {
        queue.sync {
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
    }

    func delete(_ key: KeychainKey) {
        queue.sync {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key.raw
            ]
            SecItemDelete(query as CFDictionary)
        }
    }
}
