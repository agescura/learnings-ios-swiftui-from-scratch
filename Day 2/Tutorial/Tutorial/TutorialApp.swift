import SwiftUI

@main
struct TutorialApp: App {
	var body: some Scene {
		WindowGroup {
			NavigationStack {
				ContactsView()
			}
		}
	}
}
