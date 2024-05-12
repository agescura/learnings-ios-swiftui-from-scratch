import SwiftUI

@Observable
class ContactsModel {
	var addContactModel: AddContactModel?
	var users: [User]
	
	init(
		addContactModel: AddContactModel? = nil,
		users: [User] = []
	) {
		self.addContactModel = addContactModel
		self.users = users
	}
	
	func addUserButtonTapped() {
		self.addContactModel = AddContactModel(user: .new)
	}
	
	func cancelButtonTapped() {
		self.addContactModel = nil
	}
	func confirmAddUserButtonTapped() {
		if let addUserModel = self.addContactModel {
			self.users.append(
				addUserModel.user
			)
		}
		self.addContactModel = nil
	}
}

struct ContactsView: View {
	@Bindable var model: ContactsModel = ContactsModel()
	
	var body: some View {
		List {
			ForEach(self.model.users) { user in
				VStack(alignment: .leading, spacing: 8) {
					Text(user.name)
						.font(.title3)
					Text(user.username)
						.font(.caption)
				}
			}
		}
		.navigationTitle("Contactos")
		.toolbar {
			ToolbarItem(placement: .primaryAction) {
				Button(
					action: {
						self.model.addUserButtonTapped()
					},
					label: { Image(systemName: "plus") }
				)
			}
		}
		.sheet(item: self.$model.addContactModel) { addUserModel in
			NavigationStack {
				AddContactView(model: addUserModel)
					.navigationTitle("Add User")
					.navigationBarTitleDisplayMode(.inline)
					.toolbar {
						ToolbarItem(placement: .cancellationAction) {
							Button("Cancel") {
								self.model.cancelButtonTapped()
							}
						}
						ToolbarItem(placement: .primaryAction) {
							Button("Add user") {
								self.model.confirmAddUserButtonTapped()
							}
						}
					}
			}
		}
	}
}

#Preview {
	NavigationStack {
		ContactsView(
			model: ContactsModel(
				addContactModel: nil,
				users: .mocks
			)
		)
	}
}
