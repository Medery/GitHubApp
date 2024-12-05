
import Foundation
import Combine

@MainActor
class RepositoryListViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: AlertError?

    private let fetchRepositoriesUseCase: FetchRepositoriesUseCase
    private var currentPage: Int = 1
    private var canLoadMore: Bool = true

    init(fetchRepositoriesUseCase: FetchRepositoriesUseCase) {
        self.fetchRepositoriesUseCase = fetchRepositoriesUseCase
    }

    func loadMoreIfNeeded(currentItem: Repository?) {
        guard let currentItem = currentItem else {
            loadRepositories()
            return
        }

        let thresholdIndex = repositories.index(repositories.endIndex, offsetBy: -5)
        if repositories.firstIndex(where: { $0.id == currentItem.id }) == thresholdIndex {
            loadRepositories()
        }
    }

    func loadRepositories() {
        guard !isLoading && canLoadMore else { return }
        isLoading = true
        Task { @MainActor in
            do {
                let newRepositories = try await fetchRepositoriesUseCase.execute(query: "swift", page: currentPage)
                if newRepositories.isEmpty {
                    canLoadMore = false
                } else {
                    repositories.append(contentsOf: newRepositories)
                    currentPage += 1
                }
                isLoading = false
            } catch {
                errorMessage = AlertError(message: error.localizedDescription)
                isLoading = false
            }
        }
    }

    func deleteRepository(at offsets: IndexSet) {
        repositories.remove(atOffsets: offsets)
    }

    func editRepository(_ repository: Repository, newName: String, newRepoDescription: String?) {
        if let index = repositories.firstIndex(where: { $0.id == repository.id }) {
            repositories[index].name = newName
            repositories[index].repoDescription = newRepoDescription
        }
    }
}
