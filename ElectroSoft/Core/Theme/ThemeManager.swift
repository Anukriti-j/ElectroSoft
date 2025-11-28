import SwiftUI

struct ThemeFonts {
    let heading: Font
    let subheading: Font
    let body: Font
}

struct ThemeColors {
    let primary: Color
    let secondary: Color
    let background: Color
    let cardBackground: Color
    let primaryText: Color
    let secondaryText: Color
    let buttonPrimary: Color
    let buttonSecondary: Color
    let error: Color
    let success: Color
    let fonts: ThemeFonts
}

enum AppThemeType {
    case light
    case dark
    case clientCustom
}

final class ThemeManager: ObservableObject {
    
    @Published var currentTheme: AppThemeType = .light
    
    @Published private var clientCustomTheme: ThemeColors?
    
    var colors: ThemeColors {
        switch currentTheme {
        case .light: return AppColors.light
        case .dark: return AppColors.dark
        case .clientCustom:
            return clientCustomTheme ?? AppColors.light
        }
    }
   
    func setTheme(_ theme: AppThemeType) {
        currentTheme = theme
    }
    
    func setClientCustomTheme(
        primary: Color,
        secondary: Color,
        background: Color,
        headingFont: Font,
        subheadingFont: Font,
        bodyFont: Font
    ) {
        clientCustomTheme = AppColors.clientTheme(
            primary: primary,
            secondary: secondary,
            background: background,
            headingFont: headingFont,
            subheadingFont: subheadingFont,
            bodyFont: bodyFont
        )
        currentTheme = .clientCustom
    }
}
