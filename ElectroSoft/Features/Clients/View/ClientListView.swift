import SwiftUI

struct ClientListView: View {
    @StateObject private var viewModel: ClientListViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var isRefreshing = false
    
    
    init(container: AppDependencyContainer) {
        _viewModel = StateObject(
            wrappedValue: ClientListViewModel(repository: container.clientRepository)
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            filterAndSortBar
                .animation(.spring(), value: viewModel.filterSelections)
            
            clientList
        }
        .navigationTitle("Clients")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if viewModel.clients.isEmpty {
                await viewModel.fetchClients(reset: true)
            }
        }
        .searchable(text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search clients...")
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
                        set: { newSelections in
                            viewModel.applyFilters(newSelections)
                        }
                    )
                )
                
                Spacer(minLength: 20)
                
                SortMenuView(
                    title: "Sort",
                    options: viewModel.sortOptions,
                    selection: Binding(
                        get: { viewModel.selectedSort },
                        set: { newSort in
                            viewModel.applySort(newSort)
                        }
                    )
                )
            }
            .padding(.horizontal)
        }
        .frame(height: 50)
        .padding(.top, 8)
        .background(themeManager.currentTheme.surface)
    }
    
    private var clientList: some View {
        List {
            
            ForEach(viewModel.clients) { client in
                ClientCardView(client: client)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .task {
                        await viewModel.loadNextPageIfNeeded(currentItem: client)
                    }
            }
            
            if viewModel.viewState == .loading && viewModel.currentPage < viewModel.totalPages {
                ProgressView().scaleEffect(1.5).tint(themeManager.currentTheme.primary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .background(themeManager.currentTheme.background)
        .scrollContentBackground(.hidden)
        .refreshable {
            await viewModel.refreshWithoutCancel()
        }
        .overlay {
            ZStack {
                if viewModel.clients.isEmpty {
                    themeManager.currentTheme.background.ignoresSafeArea()
                    
                    switch viewModel.viewState {
                    case .loading:
                        ProgressView().scaleEffect(1.5).tint(themeManager.currentTheme.primary)
                    case .empty:
                        emptyOrErrorStateView
                    case .error:
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
                .foregroundColor(viewModel.viewState == .empty ? .gray : themeManager.currentTheme.error)
            
            Text(viewModel.viewState == .empty ? "No Clients Found" : "Something Went Wrong")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(viewModel.viewState == .empty ? "Try adjusting your filters or search criteria." : "Could not load clients. Please try again.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            Button {
                Task { await retryLoad() }
            } label: {
                Label("Retry", systemImage: "arrow.clockwise")
                    .font(.callout.bold())
            }
            .themedButton(isDisabled: isRefreshing)
            .padding(.horizontal, 50)
            .opacity(isRefreshing ? 0.6 : 1.0)
        }
        .padding()
    }
    
    private func retryLoad() async {
        isRefreshing = true
        await viewModel.fetchClients(reset: true)
        isRefreshing = false
    }
}
