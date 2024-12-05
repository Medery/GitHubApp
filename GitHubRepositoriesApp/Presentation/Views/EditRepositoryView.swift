
import SwiftUI

struct EditRepositoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var repository: Repository
    @ObservedObject var viewModel: RepositoryListViewModel
    @State private var newName: String
    @State private var newDescription: String
    
    init(repository: Repository, viewModel: RepositoryListViewModel) {
        self._repository = State(initialValue: repository)
        self.viewModel = viewModel
        self._newName = State(initialValue: repository.name)
        self._newDescription = State(initialValue: repository.repoDescription ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Repository Info")) {
                    TextField("Name", text: $newName)
                    TextField("Description", text: $newDescription)
                }
            }
            .navigationTitle("Edit Repository")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                viewModel.editRepository(repository, newName: newName, newRepoDescription: newDescription)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
