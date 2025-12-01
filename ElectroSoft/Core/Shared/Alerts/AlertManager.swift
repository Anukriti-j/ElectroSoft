import Foundation

@MainActor
final class AlertManager: ObservableObject {
    @Published var currentAlert: AppAlert? = nil
    @Published var isPresented: Bool = false

    func showAlert(_ alert: AppAlert) {
        currentAlert = alert
        isPresented = true
    }

    func dismiss() {
        currentAlert = nil
        isPresented = false
    }
}
