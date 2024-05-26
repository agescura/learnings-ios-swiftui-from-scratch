import SwiftUI

@main
struct TutorialApp: App {
	var body: some Scene {
		WindowGroup {
			AppView(
				model: AppModel(
//					tab: .contacts,
//					contactsModel: ContactsModel(
//						addContactModel: AddContactModel(
//							user: .init(
//								name: "Albert",
//								username: "agescura",
//								country: .init(
//									flags: .init(
//										png: ""
//									),
//									name: .init(
//										common: "Spain",
//										official: "Spain"
//									)
//								)
//							),
//							countryModel: CountryModel(
//								countrySelected: nil
//							)
//						)
//					)
				)
			)
			.onOpenURL(perform: { url in
				print(url)
			})
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
