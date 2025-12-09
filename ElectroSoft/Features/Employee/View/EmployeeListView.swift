import SwiftUI

struct EmployeeListView: View {
    @StateObject private var viewModel: EmployeeListViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var session: SessionManager
    
    @State private var isRefreshing = false
    
    init(container: AppDependencyContainer) {
        _viewModel = StateObject(
            wrappedValue: EmployeeListViewModel(
                repository: container.employeeRepository,
                locationRepository: container.locationRepository
            )
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            filterAndSortBar
                .animation(.spring(), value: viewModel.filterSelections)
            
            employeeList
        }
        .navigationTitle("Employees")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if viewModel.employees.isEmpty {
                await viewModel.fetchEmployees(reset: true)
            }
        }
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search employees..."
        )
        .onChange(of: viewModel.searchText) { _, newValue in
            viewModel.updateSearchText(newValue)
        }
    }
    
    private var filterAndSortBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                
                FiltersBarView(
                    filters: viewModel.filterOptions,
                    selections: Binding(
                        get: { viewModel.filterSelections },
                        set: { viewModel.applyFilters($0) }
                    )
                )
                
                Spacer(minLength: 20)
                
                SortMenuView(
                    title: "Sort",
                    options: viewModel.sortOptions,
                    selection: Binding(
                        get: { viewModel.selectedSort },
                        set: { viewModel.applySort($0) }
                    )
                )
            }
            .padding(.horizontal)
        }
        .frame(height: 50)
        .padding(.top, 8)
        .background(themeManager.currentTheme.surface)
    }
    
    private var employeeList: some View {
        List {
            ForEach(viewModel.employees) { employee in
                EmployeeCardView(employee: employee)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .task {
                        await viewModel.loadNextPageIfNeeded(currentItem: employee)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            viewModel.deleteEmployee(employee)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
            
            if viewModel.viewState == .loading && viewModel.hasMorePages {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(themeManager.currentTheme.primary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .refreshable {
            await viewModel.refresh()
        }
        .background(themeManager.currentTheme.background)
        .overlay {
            ZStack {
                if viewModel.employees.isEmpty {
                    themeManager.currentTheme.background.ignoresSafeArea()
                    
                    switch viewModel.viewState {
                    case .loading:
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(themeManager.currentTheme.primary)
                        
                    case .empty, .error:
                        emptyOrErrorStateView
                        
                    default:
                        EmptyView()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var emptyOrErrorStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: viewModel.viewState == .empty ? "person.3.fill" : "wifi.exclamationmark")
                .font(.system(size: 50))
            
            Text(viewModel.viewState == .empty ? "No Employees Found" : "Something Went Wrong")
                .font(.headline)
            
            Text(
                viewModel.viewState == .empty
                ? "Try adjusting your filters or search criteria."
                : "Could not load employees. Please try again."
            )
            .font(.subheadline)
            .multilineTextAlignment(.center)
            
            Button {
                Task { await viewModel.fetchEmployees(reset: true) }
            } label: {
                Label("Retry", systemImage: "arrow.clockwise")
                    .font(.callout.bold())
            }
            .themedButton(isDisabled: isRefreshing)
            .padding(.horizontal, 50)
        }
        .padding()
    }
}
