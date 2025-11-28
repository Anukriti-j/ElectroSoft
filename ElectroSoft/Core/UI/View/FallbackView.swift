import SwiftUI

struct FallbackView: View {
    var body: some View {
        VStack {
            Image(systemName: "cross")
                .padding()
            Text("Something went wrong...")
        }
    }
}

#Preview {
    FallbackView()
}
