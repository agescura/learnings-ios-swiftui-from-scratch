import SwiftUI

@Observable
class AddContactModel: Identifiable, Equatable {
	static func == (lhs: AddContactModel, rhs: AddContactModel) -> Bool {
		lhs.user == rhs.user
		&& lhs.countryModel == rhs.countryModel
	}
	
	var user: User
	var countryModel: CountryModel?
	var onSave: (Country) -> Void
	
	init(
		user: User,
		countryModel: CountryModel? = nil,
		onSave: @escaping (Country) -> Void = { _ in }
	) {
		self.user = user
		self.countryModel = countryModel
		self.onSave = onSave
	}
	
	var id: User.ID {
		self.user.id
	}
	
	func selectCountryButtonTapped() {
		if let countrySelected = self.countryModel?.countrySelected {
			self.user.country = countrySelected
			self.countryModel = nil
			self.onSave(countrySelected)
		}
	}
	
	func countryButtonTapped() {
		if self.user.country != .empty {
			self.countryModel = CountryModel(
				countrySelected: self.user.country
			)
		} else {
			self.countryModel = CountryModel()
		}
		
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
				HStack {
					Text(self.model.user.country == .empty ? "No country" : self.model.user.country.name.official)
					Spacer()
					Button("Select your country") {
						self.model.countryButtonTapped()
					}
					.buttonStyle(.plain)
				}
			}
			.textCase(nil)
		}
		.navigationDestination(item: self.$model.countryModel) { model in
			CountryView(model: model)
				.navigationTitle("Countries")
				.toolbar {
					ToolbarItem(placement: .primaryAction) {
						Button("Select country") {
							self.model.selectCountryButtonTapped()
						}
					}
				}
		}
	}
}

#Preview {
	NavigationStack {
		AddContactView(
			model: AddContactModel(user: User(name: "albert", username: "agescura", country: .empty))
		)
		.navigationTitle("Add User")
		.navigationBarTitleDisplayMode(.inline)
	}
}
