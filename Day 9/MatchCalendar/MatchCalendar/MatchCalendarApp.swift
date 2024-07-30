import SwiftUI

@main
struct MatchCalendarApp: App {
    var body: some Scene {
        WindowGroup {
			  ContentView(
				model: ContentModel()
			  )
        }
    }
}
