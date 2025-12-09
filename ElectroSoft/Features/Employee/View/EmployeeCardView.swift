import SwiftUI

struct EmployeeCardView: View {
    let employee: Employee
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            HStack(alignment: .center, spacing: 12) {
                Circle()
                    .fill(themeManager.currentTheme.primary.opacity(0.1))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Text(String(employee.name.prefix(1)).uppercased())
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(themeManager.currentTheme.primary)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(employee.name)
                        .font(.headline)
                        .foregroundColor(themeManager.currentTheme.text)
                        .lineLimit(1)
                    
                    Text(employee.email)
                        .font(.caption)
                        .foregroundColor(themeManager.currentTheme.text.opacity(0.6))
                        .lineLimit(1)
                }
                
                Spacer()
                
                Text(employee.status.uppercased())
                    .customStatusStyle(status: employee.status)
            }
            
            Divider()
                .background(themeManager.currentTheme.text.opacity(0.1))
            
            HStack(spacing: 0) {
                DetailItem(
                    icon: "briefcase.fill",
                    text: employee.role,
                    color: themeManager.currentTheme.primary
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if let location = getLocationString() {
                    DetailItem(
                        icon: "mappin.and.ellipse",
                        text: location,
                        color: themeManager.currentTheme.secondary
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
            }
        }
        .padding(16)
        .background(themeManager.currentTheme.surface)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private func getLocationString() -> String? {
        if let city = employee.city { return city }
        if let district = employee.district { return district }
        return employee.state
    }
}

private struct DetailItem: View {
    let icon: String
    let text: String
    let color: Color
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(color)
            
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(themeManager.currentTheme.text.opacity(0.8))
                .lineLimit(1)
        }
    }
}
