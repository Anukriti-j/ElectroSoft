
import SwiftUI

struct NoInternetView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 50))
                .foregroundColor(themeManager.colors.error)
            Text("No Internet Connection")
                .font(.title2)
                .bold()
            Text("Please check your connection and try again.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview {
    NoInternetView()
        .environmentObject(ThemeManager())
}

