import SwiftUI

struct SortMenuView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    let title: String
    let options: [SortOption]
    
    @Binding var selection: SortOption?
    
    var body: some View {
        Menu {
            if selection != nil {
                Button("Clear Sort") {
                    selection = nil
                }
                Divider()
            }
            ForEach(options) { option in
                Button(action: {
                    selection = option
                }) {
                    Label(
                        option.displayName,
                        systemImage: selection == option ? "checkmark.circle.fill" : "circle"
                    )
                }
            }
        } label: {
            HStack {
                Text(selection?.displayName ?? title)
                    .font(.subheadline)
                    .foregroundStyle(themeManager.currentTheme.primary)
                
                Image(systemName: "chevron.down")
                    .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(themeManager.currentTheme.surface)
            .foregroundColor(themeManager.currentTheme.text.opacity(0.8))
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
        }
    }
}

#if DEBUG
#Preview {
    let sortOptions: [SortOption] = [
        .init(id: "name_asc", displayName: "Name A-Z", serverKey: "name", direction: .ascending),
        .init(id: "name_desc", displayName: "Name Z-A", serverKey: "name", direction: .descending),
        .init(id: "date_desc", displayName: "Newest First", serverKey: "createdAt", direction: .descending)
    ]
    
    @State var selection: SortOption? = sortOptions[0]
    
    ZStack {
        Color.gray.opacity(0.1).ignoresSafeArea()
        SortMenuView(
            title: "Sort",
            options: sortOptions,
            selection: $selection
        )
        .environmentObject(ThemeManager())
        .padding()
    }
}
#endif
