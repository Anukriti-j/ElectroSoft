import SwiftUI

struct SortListSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    
    let sortOptions: [String]
    @State private var selectedSort: String?
    
    var onApply: ((String?) -> Void)
    
    init(initialSelection: String?, sortOptions: [String], onApply: @escaping (String?) -> Void) {
        self._selectedSort = State(initialValue: initialSelection)
        self.sortOptions = sortOptions
        self.onApply = onApply
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("Sort By")
                    .font(.title2.bold())
                    .foregroundColor(themeManager.currentTheme.text)
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray.opacity(0.5))
                }
            }
            .padding()
            
            Divider()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(sortOptions, id: \.self) { option in
                        optionRow(for: option)
                    }
                }
                .padding()
            }
            
            Divider()
            
            footerButtons
        }
        .background(themeManager.currentTheme.background.ignoresSafeArea())
    }
    
    @ViewBuilder
    private func optionRow(for option: String) -> some View {
        Button(action: { selectedSort = option }) {
            HStack(spacing: 15) {
                Image(systemName: selectedSort == option ? "largecircle.fill.circle" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(themeManager.currentTheme.primary)
                
                Text(option)
                    .font(.body)
                    .foregroundColor(themeManager.currentTheme.text)
                
                Spacer()
            }
        }
        .buttonStyle(.plain)
    }
    
    private var footerButtons: some View {
        HStack(spacing: 15) {
            Button("Clear") {
                selectedSort = nil
            }
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(themeManager.currentTheme.error)
            .background(themeManager.currentTheme.error.opacity(0.1))
            .cornerRadius(12)
            
            Button("Apply") {
                onApply(selectedSort)
                dismiss()
            }
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(themeManager.currentTheme.primary)
            .cornerRadius(12)
        }
        .padding()
    }
}

#if DEBUG
#Preview {
    SortListSheetView(
        initialSelection: "Newest First",
        sortOptions: [
            "Newest First", "Oldest First",
            "Name A-Z", "Name Z-A"
        ],
        onApply: { selected in
            print("Selected sort:", selected ?? "none")
        }
    )
    .environmentObject(ThemeManager())
}
#endif
