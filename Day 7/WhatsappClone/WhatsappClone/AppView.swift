import SwiftUI

/*
 TabView
 
	selection: $....
	data: [.......]
 */

enum Tab {
	case updates, calls, community, chats, settings
}

struct AppView: View {
	@State var selectedTab = Tab.chats
	
	var body: some View {
		TabView(selection: self.$selectedTab) {
			Text("Actualizacioens")
				.tabItem {
					Text("Actualizacioens")
						.foregroundColor(.green)
				}
				.tag(Tab.updates)
			Text("Llamadas")
				.tabItem {
					Image(systemName: "phone")
					Text("Llamadas")
						.foregroundStyle(.green)
				}
				.tag(Tab.calls)
			Text("Comunidades")
				.tabItem {
					Image(systemName: "person.3")
					Text("Comunidades")
				}
				.tag(Tab.community)
			ChatListView()
				.tabItem {
					Text("Chats")
				}
				.tag(Tab.chats)
			Text("Configuraciones")
				.tabItem {
					Image(systemName: "gear")
					Text("Configuraciones")
				}
				.tag(Tab.settings)
		}
		.accentColor(Color.black)
	}
}

#Preview {
	AppView()
}
