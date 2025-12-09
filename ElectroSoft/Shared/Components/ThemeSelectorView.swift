import SwiftUI

struct ThemeSelectorView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                ForEach(ThemeType.allCases) { type in
                    ThemeButton(type: type, isSelected: themeManager.selectedType == type) {
                        themeManager.applyTheme(type)
                    }
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 10)
    }
}

private struct ThemeButton: View {
    let type: ThemeType
    let isSelected: Bool
    let action: () -> Void
    
    private var previewTheme: AppTheme { AppTheme.get(type) }
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Circle()
                    .fill(previewTheme.primary)
                    .frame(width: 38, height: 38)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: isSelected ? 2.5 : 0)
                            .shadow(radius: isSelected ? 2 : 0)
                    )
                    .overlay(
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .opacity(isSelected ? 1 : 0)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                
                Text(type.displayName)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(themeManager.currentTheme.text)
                    .lineLimit(1)
            }
        }
        .frame(width: 60)
        .accessibilityLabel("Select \(type.displayName) theme")
        .accessibilityAddTraits(isSelected ? .isSelected : .isButton)
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}
