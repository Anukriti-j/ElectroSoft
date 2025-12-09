import SwiftUI

struct ClientCardView: View {
    let client: Client
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(client.clientName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(themeManager.currentTheme.text)
                    
                    Text("Rep: \(client.representativeName)")
                        .font(.caption)
                        .foregroundColor(themeManager.currentTheme.text.opacity(0.7))
                }
                
                Spacer()
                
                Text(client.status.rawValue.uppercased())
                    .customStatusStyle(status: client.status.rawValue)
            }
            
            Divider()
            
            HStack {
                Label(client.subscriptionPlan, systemImage: "creditcard.fill")
                    .font(.caption)
                    .foregroundColor(themeManager.currentTheme.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray.opacity(0.5))
            }
        }
        .padding()
        .background(themeManager.currentTheme.surface)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}
