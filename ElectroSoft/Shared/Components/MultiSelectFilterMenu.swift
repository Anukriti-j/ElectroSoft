import SwiftUI

struct MultiSelectFilterMenu: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    let title: String
    let options: [String]
    @Binding var selections: Set<String>
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: { toggle(option) }) {
                    Label(
                        option,
                        systemImage: selections.contains(option) ? "checkmark.square.fill" : "square"
                    )
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(title)
                
                if !selections.isEmpty {
                    Text("(\(selections.count))")
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.currentTheme.primary)
                }
                
                Image(systemName: "chevron.down")
                    .font(.caption)
            }
            .font(.subheadline)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(themeManager.currentTheme.surface)
            .foregroundColor(themeManager.currentTheme.text.opacity(0.8))
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
        }
    }
    
    private func toggle(_ value: String) {
        if selections.contains(value) {
            selections.remove(value)
        } else {
            selections.insert(value)
        }
    }
}
