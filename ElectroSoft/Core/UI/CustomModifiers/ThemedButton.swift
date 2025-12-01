import SwiftUI

struct ThemedButtonStyle: ButtonStyle {
    @EnvironmentObject private var theme: ThemeManager
    var isDisabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        let bgColor = isDisabled ? .gray : theme.colors.buttonPrimary
        let textColor = isDisabled ? theme.colors.secondaryText : theme.colors.primaryText
        
        return configuration.label
            .foregroundStyle(textColor)
            .font(theme.colors.fonts.subheading)
            .padding()
            .frame(maxWidth: .infinity)
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .opacity(isDisabled ? 0.6 : (configuration.isPressed ? 0.85 : 1))
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct ThemedButtonModifier: ViewModifier {
    var isDisabled: Bool = false
    
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


