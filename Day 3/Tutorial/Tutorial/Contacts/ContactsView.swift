import SwiftUI

@Observable
class ContactsModel: Equatable {
	static func == (lhs: ContactsModel, rhs: ContactsModel) -> Bool {
		lhs.addContactModel == rhs.addContactModel
		&& lhs.users == rhs.users
	}
	
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
		self.addContactModel = AddContactModel(user: .new, onSave: { country in
			print(country)
		})
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
	func deleteUsersButtonTapped(_ indexSet: IndexSet) {
		for index in indexSet {
			self.users.remove(at: index)
		}
	}
}

struct ContactsView: View {
	@Bindable var model: ContactsModel = ContactsModel()
	
	var body: some View {
		List {
			ForEach(self.model.users) { user in
				VStack(alignment: .leading, spacing: 8) {
					Text(user.name)
						.font(.title)
					Text(user.username)
						.font(.caption)
				}
			}
			.onDelete { indexSet in
				self.model.deleteUsersButtonTapped(indexSet)
			}
		}
		.navigationTitle("Contactos")
		.toolbar {
			ToolbarItem(placement: .primaryAction) {
				Button {
					self.model.addUserButtonTapped()
				} label: {
					Image(systemName: "plus")
				}
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
