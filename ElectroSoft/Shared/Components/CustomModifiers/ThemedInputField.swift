import SwiftUI

struct ThemedInputField: ViewModifier {
    @EnvironmentObject var themeManager: ThemeManager
    
    var isFocused: Bool
    var error: String?
    var isTouched: Bool
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(themeManager.currentTheme.surface)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 1.5)
            )
            .foregroundColor(themeManager.currentTheme.text)
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            .animation(.easeInOut(duration: 0.2), value: error)
    }
    
    private var borderColor: Color {
        if isTouched, error != nil {
            return themeManager.currentTheme.error
        }
        if isFocused {
            return themeManager.currentTheme.primary.opacity(0.5)
        }
        return Color.clear
    }
}

extension View {
    func themedInput(isFocused: Bool = false, error: String? = nil, isTouched: Bool = false) -> some View {
        self.modifier(ThemedInputField(isFocused: isFocused, error: error, isTouched: isTouched))
    }
}
