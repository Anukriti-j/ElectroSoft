import SwiftUI

enum TabItem: String, CaseIterable, Identifiable, Equatable {
    case dashboard
    case employee
    case client
    case addEmployee
    case bill
    case issues
    case invoice
    case plan
    case fallback

    var id: String { rawValue }

    var title: String {
        switch self {
        case .dashboard:
            return "Dashboard"
        case .employee:
            return "Employee"
        case .client:
            return "Clients"
        case .addEmployee:
            return "Add Employee"
        case .bill:
            return "Bills"
        case .issues:
            return "Issues"
        case .invoice:
            return "Invoices"
        case .plan:
            return "Subscription"
        case .fallback:
            return ""
        }
    }

    var icon: String {
        switch self {
        case .dashboard:
            return "rectangle.grid.2x2.fill"
        case .employee:
            return "person.2.fill"
        case .client:
            return "person.crop.circle.badge.checkmark"
        case .addEmployee:
            return "person.badge.plus"
        case .bill:
            return "doc.text.fill"
        case .issues:
            return "exclamationmark.triangle.fill"
        case .invoice:
            return "doc.text.fill"
        case .plan:
            return "creditcard" 
        case .fallback:
            return ""
        }
    }

    @ViewBuilder
    var destination: some View {
        switch self {
        case .dashboard:
             DashboardView()
        case .employee:
            EmployeeListView()
        case .client:
            ClientListView()
        case .addEmployee:
            EmployeeListView()
        case .bill:
            MeterBillView()
        case .issues:
            CustomerIssuesView()
        case .invoice:
            InvoiceView()
        case .plan:
            SubscriptionPlanListView()
        case .fallback:
            FallbackView()
        }
    }
}
