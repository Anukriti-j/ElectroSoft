import SwiftUI

struct FiltersBarView: View {
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
                .font(.caption)
                .fontWeight(.semibold)
            Image(systemName: "chevron.down")
                .font(.caption2)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}
