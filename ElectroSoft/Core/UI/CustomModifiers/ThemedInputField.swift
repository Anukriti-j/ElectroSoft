
import SwiftUI

struct ThemedInputField: ViewModifier {
    @EnvironmentObject var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(themeManager.colors.cardBackground)
            .foregroundColor(themeManager.colors.primaryText)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(themeManager.colors.primary, lineWidth: 1.2)
            )
    }
}

extension View {
    func themedInput() -> some View {
        self.modifier(ThemedInputField())
    }
}
