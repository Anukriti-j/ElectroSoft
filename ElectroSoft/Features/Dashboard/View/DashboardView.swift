import SwiftUI

struct DashboardView: View {
    
    var body: some View {
        NavigationStack {
            VStack {
                PieChartView(data: mockRoles)
                    .frame(width: 300, height: 300)
                    .padding()
                Spacer()
            }
            .navigationTitle(StringConstants.dashboard)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DashboardView()
}

