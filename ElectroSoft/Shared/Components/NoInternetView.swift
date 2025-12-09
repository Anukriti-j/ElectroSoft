import SwiftUI

struct NoInternetView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "wifi.exclamationmark")
                .font(.headline)
            Text("No Internet Connection")
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.red)
        .cornerRadius(12)
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.2), radius: 5, y: 3)
    }
}
