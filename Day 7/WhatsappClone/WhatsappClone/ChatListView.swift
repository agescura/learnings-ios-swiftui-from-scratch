import SwiftUI

enum TopButton: TopTabItem {
	case all, notReaded, groups
	
	var key: String {
		switch self {
			case .all:
				return "Todos"
			case .notReaded:
				return "No leidos"
			case .groups:
				return "Grupos"
		}
	}
}

//enum Styles: TopTabItem {
//	case negro, blanco
//	
//	var key: String {
//		switch self {
//			case .negro:
//				return "Negro"
//			case .blanco:
//				return "Blanco"
//		}
//	}
//}

protocol TopTabItem: Hashable {
	var key: String { get }
}

struct TopTabView<TopTabItem: Hashable, Label: View>: View {
	@Binding var selected: TopTabItem
	let options: [TopTabItem]
	@ViewBuilder let label: (TopTabItem) -> Label
	
	var body: some View {
		HStack {
			ForEach(options, id: \.self) { option in
				Button {
					self.selected = option
				} label: {
					label(option)
				}
				.buttonStyle(.topButton(self.selected == option))
			}
		}
	}
}

struct ChatListView: View {
	@State var searchText = ""
	@State var selectedTopButton: TopButton = .all
	
	var body: some View {
		NavigationStack {
			List {
				TopTabView(
					selected: self.$selectedTopButton,
					options: [.all, .notReaded, .groups]
				) { item in
					Text(item.key)
				}
				.listRowSeparator(.hidden)
				
//				TopTabView(
//					selected: .constant(Styles.blanco),
//					options: [.negro, .blanco]
//				) { item in
//					Text(item.key)
//				}
				
				ForEach(0..<100) { _ in
					ChatListRowView()
				}
			}
			.listStyle(.plain)
			.navigationTitle("Xats")
			.toolbar {
				
				ToolbarItem(placement: .confirmationAction) {
					Text("Confirm")
				}
				ToolbarItem(placement: .confirmationAction) {
					Image(systemName: "plus.circle.fill")
						.foregroundColor(.green)
						.background(Color.white)
						.clipShape(Circle())
				}
				ToolbarItem(placement: .cancellationAction) {
					Text("Cancel")
				}
			}
		}
		.searchable(text: $searchText)
	}
}

struct ChatListTopButtonStyle: ButtonStyle {
	let isSelected: Bool
	
	func makeBody(configuration: Configuration) -> some View {
		configuration.label
			.padding(.vertical, 4)
			.padding(.horizontal, 8)
			.background(
				Color(red: 0, green: 0, blue: 0.5)
					.opacity(isSelected ? 1.0 : 0.5)
			)
			.foregroundStyle(.white)
			.clipShape(Capsule())
	}
}

extension ButtonStyle where Self == ChatListTopButtonStyle {
	static func topButton(_ isSelected: Bool) -> Self {
		ChatListTopButtonStyle(isSelected: isSelected)
	}
}

#Preview {
	ChatListView()
}
