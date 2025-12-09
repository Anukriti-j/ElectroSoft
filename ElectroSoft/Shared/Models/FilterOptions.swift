import Foundation

struct FilterOption: Identifiable, Hashable {
    let id = UUID()
    let key: String
    let title: String
    let values: [String]
}

struct SortOption: Identifiable, Hashable {
    let id: String
    let displayName: String
    let serverKey: String
    let direction: SortDirection
}

enum SortDirection: String {
    case ascending = "ASC"
    case descending = "DESC"
}
