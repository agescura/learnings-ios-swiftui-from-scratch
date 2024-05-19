import SwiftUI

@main
struct TutorialApp: App {
	var body: some Scene {
		WindowGroup {
			AppView(
				model: AppModel(
					tab: .contacts,
					contactsModel: ContactsModel(
						addContactModel: AddContactModel(
							user: .init(name: "", username: "", country: .empty),
							countryModel: CountryModel(
								countrySelected: nil
							)
						)
					)
				)
			)
			.onOpenURL(perform: { url in
				print(url)
			})
		}
	}
}

enum Tab {
	case contacts, weather
}

@Observable
class AppModel {
	var tab: Tab
	var contactsModel: ContactsModel
	
	init(
		tab: Tab  = .contacts,
		contactsModel: ContactsModel = ContactsModel()
	) {
		self.tab = tab
		self.contactsModel = contactsModel
	}
}

struct AppView: View {
	@Bindable var model: AppModel
	
	var body: some View {
		TabView(selection: self.$model.tab) {
			NavigationStack {
				ContactsView(
					model: self.model.contactsModel
				)
			}
			.tabItem {
				Text("Contactos")
			}
			.tag(Tab.contacts)
			Text("El tiempo")
				.tabItem {
					Text("El tiempo")
				}
				.tag(Tab.weather)
		}
	}
}

#Preview {
	AppView(
		model: AppModel(
			tab: .weather
		)
	)
}
