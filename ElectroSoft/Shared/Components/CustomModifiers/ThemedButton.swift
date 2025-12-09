import SwiftUI

struct ThemedButtonStyle: ButtonStyle {
    @EnvironmentObject private var themeManager: ThemeManager
    var isDisabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        let backgroundColor = isDisabled
        ? Color.gray.opacity(0.5)
        : themeManager.currentTheme.primary
        
        let foregroundColor = Color.white
        
        return configuration.label
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundStyle(foregroundColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isDisabled)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct ThemedButtonModifier: ViewModifier {
    var isDisabled: Bool
    
    func body(content: Content) -> some View {
        content
            .buttonStyle(ThemedButtonStyle(isDisabled: isDisabled))
            .disabled(isDisabled)
    }
}

extension View {
    func themedButton(isDisabled: Bool = false) -> some View {
        self.modifier(ThemedButtonModifier(isDisabled: isDisabled))
    }
}
