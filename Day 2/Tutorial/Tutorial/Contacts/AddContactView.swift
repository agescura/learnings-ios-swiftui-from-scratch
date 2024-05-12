import SwiftUI

@Observable
class AddContactModel: Identifiable {
	var user: User
	var countryIsPresented = false
	
	init(
		user: User
	) {
		self.user = user
	}
	
	var id: User.ID {
		self.user.id
	}
}

struct AddContactView: View {
	@Bindable var model: AddContactModel
	
	var body: some View {
		Form {
			Section(header: Text("Write a name")) {
				TextField("Name", text: self.$model.user.name)
			}
			.textCase(nil)
			Section(header: Text("Username")) {
				TextField("Username", text: self.$model.user.username)
			}
			.textCase(nil)
			Section(header: Text("Country")) {
				Button("Select your country") {
					self.model.countryIsPresented = true
				}
				.buttonStyle(.plain)
			}
			.textCase(nil)
		}
		.navigationDestination(
			isPresented: self.$model.countryIsPresented
		) {
			CountryView(
				model: CountryModel()
			)
			.navigationTitle("Countries")
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					Button("Select country") {
					}
				}
			}
		}
	}
}

#Preview {
	NavigationStack {
		AddContactView(
			model: AddContactModel(user: User(name: "albert", username: "agescura", country: "spain"))
		)
		.navigationTitle("Add User")
		.navigationBarTitleDisplayMode(.inline)
	}
}
