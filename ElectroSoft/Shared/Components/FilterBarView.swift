import SwiftUI

struct FiltersBarView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    let filters: [FilterOption]
    @Binding var selections: [String: String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(filters) { filter in
                    Menu {
                        ForEach(filter.values, id: \.self) { value in
                            Button {
                                selections[filter.key] = value
                            } label: {
                                HStack {
                                    Text(value)
                                    if selections[filter.key] == value {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    } label: {
                        filterChip(
                            title: selections[filter.key] ?? filter.title
                        )
                    }
                }
            }
        }
    }
    
    private func filterChip(title: String) -> some View {
        HStack(spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(themeManager.currentTheme.primary)
            
            Image(systemName: "chevron.down")
                .font(.caption2)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(themeManager.currentTheme.surface)
        .foregroundColor(themeManager.currentTheme.text.opacity(0.8))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
    }
}

#if DEBUG
#Preview {
    struct FiltersBarPreviewWrapper: View {
        
        let sampleFilters: [FilterOption] = [
            .init(key: "status", title: "Status", values: ["Active", "Inactive", "Pending"]),
            .init(key: "priority", title: "Priority", values: ["High", "Medium", "Low"])
        ]
        
        @State private var currentSelections: [String: String] = [
            "status": "Active" // Start with one filter pre-selected
        ]
        
        var body: some View {
            VStack(spacing: 30) {
                Text("Selected Filters:")
                    .font(.headline)
                
                Text(currentSelections.map { "\($0.key): \($0.value)" }.joined(separator: ", "))
                    .font(.caption)
                
                Spacer()
                
                FiltersBarView(
                    filters: sampleFilters,
                    selections: $currentSelections
                )
                .environmentObject(ThemeManager())
                
                Spacer()
            }
            .padding()
        }
    }
    
    return FiltersBarPreviewWrapper()
}
#endif
