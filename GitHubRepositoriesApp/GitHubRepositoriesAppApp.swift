
import SwiftUI
import SwiftData

@main
struct GitHubRepositoriesApp: App {
    var body: some Scene {
        WindowGroup {
            RepositoryListView()
                .modelContainer(for: LocalRepository.self)
        }
    }
}
