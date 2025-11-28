import SwiftUI

struct UserRoleTextModifier: ViewModifier {
    @EnvironmentObject var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        content
            .font(.caption.weight(.medium))
            .foregroundColor(themeManager.colors.primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(Color.blue.opacity(0.1))
            .clipShape(Capsule())
    }
}

extension View {
    func customRoleStyle() -> some View {
        modifier(UserRoleTextModifier())
    }
}
