import SwiftUI

struct FilterSortBar: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var showFilterSheet: Bool
    @Binding var showSortSheet: Bool
    
    var body: some View {
        HStack {
            Button {
                showFilterSheet.toggle()
            } label: {
                Label("Filter", systemImage: "slider.horizontal.3")
                    .padding(.horizontal, 12).padding(.vertical, 8)
                    .background(themeManager.currentTheme.surface)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(themeManager.currentTheme.primary.opacity(0.3), lineWidth: 1))
                    .foregroundColor(themeManager.currentTheme.primary)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            Button {
                showSortSheet.toggle()
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
                    .padding(.horizontal, 12).padding(.vertical, 8)
                    .background(themeManager.currentTheme.surface)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(themeManager.currentTheme.primary.opacity(0.3), lineWidth: 1))
                    .foregroundColor(themeManager.currentTheme.primary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

#Preview {
    FilterSortBar(showFilterSheet: .constant(true), showSortSheet: .constant(true))
}
