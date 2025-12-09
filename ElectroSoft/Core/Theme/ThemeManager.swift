import SwiftUI

final class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme
    @Published var selectedType: ThemeType {
        didSet {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentTheme = AppTheme.get(selectedType)
            }
            saveTheme()
        }
    }
    
    private let userDefaultsKey = "selected_theme_preference"
    
    init() {
        let savedRawValue = UserDefaults.standard.string(forKey: "selected_theme_preference") ?? ThemeType.electroBlue.rawValue
        let type = ThemeType(rawValue: savedRawValue) ?? .electroBlue
        
        self.selectedType = type
        self.currentTheme = AppTheme.get(type)
    }
    
    func applyTheme(_ type: ThemeType) {
        self.selectedType = type
    }
    
    private func saveTheme() {
        UserDefaults.standard.setValue(selectedType.rawValue, forKey: userDefaultsKey)
    }
}
