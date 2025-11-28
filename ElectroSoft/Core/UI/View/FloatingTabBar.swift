import SwiftUI

struct FloatingTabBar: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var selected: TabItem
    let tabs: [TabItem]
    
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs) { tab in
                tabButton(tab)
            }
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 14)
        .background(.ultraThinMaterial)
        .cornerRadius(30)
        .padding(.bottom, 20)
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: selected)
    }
    
    @ViewBuilder
    private func tabButton(_ tab: TabItem) -> some View {
        let isActive = selected == tab
        
        Button(action: {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                selected = tab
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .scaleEffect(isActive ? 1.15 : 1.0)
                    .foregroundColor(isActive ? .white : .gray.opacity(0.6))
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isActive)
                
                Text(tab.title)
                    .font(.caption2)
                    .foregroundColor(isActive ? .white : .gray.opacity(0.7))
                    .opacity(isActive ? 1 : 0.8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                ZStack {
                    if isActive {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(themeManager.colors.primary)
                            .matchedGeometryEffect(id: "TAB_BG", in: animation)
                            .padding(.horizontal, 4)
                    }
                }
            )
        }
        .buttonStyle(.plain)
    }
}
