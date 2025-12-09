import SwiftUI

struct AppAlert {
    let title: String
    let message: String?
    let primaryButtonTitle: String
    let secondaryButtonTitle: String?
    let primaryAction: (() -> Void)?
    let secondaryAction: (() -> Void)?
    
    static func simple(title: String, message: String?) -> AppAlert {
        AppAlert(
            title: title,
            message: message,
            primaryButtonTitle: StringConstants.ok,
            secondaryButtonTitle: nil,
            primaryAction: nil,
            secondaryAction: nil
        )
    }
}
