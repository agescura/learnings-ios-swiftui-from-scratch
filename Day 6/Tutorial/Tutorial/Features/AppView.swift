import SwiftUI

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
			
			WeatherView(model: WeatherModel())
				.tabItem {
					Text("El tiempo")
				}
				.tag(Tab.weather)
		}
	}
}

