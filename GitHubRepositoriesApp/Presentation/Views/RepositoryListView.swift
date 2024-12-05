
import SwiftUI
import SwiftData

struct RepositoryListView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: RepositoryListViewModel
    @State private var isEditing: Bool = false
    @State private var selectedRepository: Repository?

    init() {
        let apiService = APIService()
        let repositoryRepository = RepositoryRepositoryImpl(apiService: apiService)
        let fetchUseCase = FetchRepositoriesUseCaseImpl(repository: repositoryRepository)
        _viewModel = StateObject(wrappedValue: RepositoryListViewModel(fetchRepositoriesUseCase: fetchUseCase))
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.repositories) { repo in
                    RepositoryRowView(repository: repo)
                        .onAppear {
                            viewModel.loadMoreIfNeeded(currentItem: repo)
                        }
                        .onTapGesture {
                            selectedRepository = repo
                            isEditing = true
                        }
                }
                .onDelete(perform: deleteRepository)

                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
            .navigationTitle("GitHub Repos")
            .alert(item: $viewModel.errorMessage) { error in
                Alert(
                    title: Text("Ошибка"),
                    message: Text(error.message),
                    dismissButton: .default(Text("OK"))
                )
            }
            .sheet(isPresented: $isEditing) {
                if let repo = selectedRepository {
                    EditRepositoryView(repository: repo, viewModel: viewModel)
                }
            }
            .toolbar {
                EditButton()
            }
        }
        .onAppear {
            viewModel.loadRepositories()
        }
    }

    func deleteRepository(at offsets: IndexSet) {
        viewModel.deleteRepository(at: offsets)
    }
}

struct AlertError: Identifiable {
    let id = UUID()
    let message: String
}
