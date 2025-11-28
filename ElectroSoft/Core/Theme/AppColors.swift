import SwiftUI

struct AppColors {
    static let light = ThemeColors(
        primary: Color("PrimaryLight"),
        secondary: Color("SecondaryLight"),
        background: Color.white,
        cardBackground: Color("CardBackgroundLight"),
        primaryText: Color.black,
        secondaryText: Color.gray,
        buttonPrimary: Color("PrimaryButtonLight"),
        buttonSecondary: Color("SecondaryButtonLight"),
        error: .red,
        success: .green,
        fonts: ThemeFonts(
            heading: Font.system(size: 24, weight: .bold),
            subheading: Font.system(size: 18, weight: .semibold),
            body: Font.system(size: 14)
        )
    )
    
    static let dark = ThemeColors(
        primary: Color.purple,
        secondary: Color.yellow,
        background: Color.black,
        cardBackground: Color("CardBackgroundDark"),
        primaryText: Color.white,
        secondaryText: Color.gray.opacity(0.8),
        buttonPrimary: Color("PrimaryButtonDark"),
        buttonSecondary: Color("SecondaryButtonDark"),
        error: .red,
        success: .green,
        fonts: ThemeFonts(
            heading: Font.system(size: 24, weight: .bold),
            subheading: Font.system(size: 18, weight: .semibold),
            body: Font.system(size: 14)
        )
    )
    
    static func clientTheme(
        primary: Color,
        secondary: Color,
        background: Color,
        headingFont: Font,
        subheadingFont: Font,
        bodyFont: Font
    ) -> ThemeColors {
        ThemeColors(
            primary: primary,
            secondary: secondary,
            background: background,
            cardBackground: background.opacity(0.9),
            primaryText: .white,
            secondaryText: .gray,
            buttonPrimary: primary,
            buttonSecondary: secondary,
            error: .red,
            success: .green,
            fonts: ThemeFonts(
                heading: headingFont,
                subheading: subheadingFont,
                body: bodyFont
            )
        )
    }
}
