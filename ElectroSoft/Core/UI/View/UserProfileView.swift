import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var session: SessionManager
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var isOpen: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(themeManager.colors.primary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(session.user?.name ?? "Guest User")
                            .font(.title3.bold())
                            .foregroundColor(themeManager.colors.primaryText)
                            .lineLimit(1)
                        
                        Text(session.user?.email ?? "No email")
                            .font(.caption)
                            .foregroundColor(themeManager.colors.secondaryText)
                            .lineLimit(1)
                        
                        Text(session.userRole.rawValue.capitalized)
                            .font(.subheadline.bold())
                            .customRoleStyle()
                    }
                }
                .padding(.horizontal, 24)
            }
            .padding(.top, 60)
            .padding(.bottom, 24)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
                .padding(.horizontal, 24)
                .background(themeManager.colors.background)
            
            Spacer()
            
            Divider()
                .padding(.horizontal, 24)
                .background(themeManager.colors.background)
            
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isOpen = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    session.logout()
                }
            } label: {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                    Text("Logout")
                        .font(.headline)
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(themeManager.colors.background)
        .edgesIgnoringSafeArea(.all)
    }
}
