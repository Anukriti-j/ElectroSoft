import SwiftUI

enum ThemeType: String, CaseIterable, Identifiable, Codable {
    case electroBlue
    case forestGreen
    case sunsetOrange
    case midnightDark
    
    var id: String { self.rawValue }
    
    var displayName: String {
        switch self {
        case .electroBlue: return "Electro Blue"
        case .forestGreen: return "Nature"
        case .sunsetOrange: return "Sunset"
        case .midnightDark: return "Midnight"
        }
    }
}

struct AppTheme {
    let type: ThemeType
    let primary: Color
    let secondary: Color
    let background: Color
    let surface: Color
    let text: Color
    let error: Color
    
    static func get(_ type: ThemeType) -> AppTheme {
        switch type {
        case .electroBlue:
            return AppTheme(
                type: .electroBlue,
                primary: Color.blue,
                secondary: Color.cyan,
                background: Color(UIColor.systemGroupedBackground),
                surface: Color.white,
                text: Color.black,
                error: Color.red
            )
        case .forestGreen:
            return AppTheme(
                type: .forestGreen,
                primary: Color.green,
                secondary: Color.mint,
                background: Color(red: 0.95, green: 0.98, blue: 0.95),
                surface: Color.white,
                text: Color(red: 0.1, green: 0.3, blue: 0.1),
                error: Color.orange
            )
        case .sunsetOrange:
            return AppTheme(
                type: .sunsetOrange,
                primary: Color.orange,
                secondary: Color.pink,
                background: Color(red: 1.0, green: 0.98, blue: 0.95),
                surface: Color.white,
                text: Color(red: 0.3, green: 0.1, blue: 0.0),
                error: Color.red
            )
        case .midnightDark:
            return AppTheme(
                type: .midnightDark,
                primary: Color.purple,
                secondary: Color.indigo,
                background: Color.black,
                surface: Color(white: 0.1),
                text: Color.white,
                error: Color(red: 1.0, green: 0.4, blue: 0.4)
            )
        }
    }
}
