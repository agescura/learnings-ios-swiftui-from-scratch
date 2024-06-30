import SwiftUI

@main
struct WhatsappCloneApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
	var body: some Scene {
		WindowGroup {
			AppView()
		}
	}
}
