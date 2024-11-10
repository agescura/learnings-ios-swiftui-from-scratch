import SwiftUI

@Observable
class MainModel {
	var inventoryModel: InventoryModel
	var selectedTab: Tab
	
	init(
		inventoryModel: InventoryModel,
		selectedTab: Tab = .inventory
	) {
		self.inventoryModel = inventoryModel
		self.selectedTab = selectedTab
	}
	
	func open(url: URL) {
		print(url)
		
//		guard let itemRowModel = inventoryModel.inventory.first(where: { $0.item.id == UUID(uuidString: url.lastPathComponent) }) else { return }
//		
//		inventoryModel.inventory[0].itemToDelete = itemRowModel.item
	}
}

struct MainView: View {
	@Bindable var model: MainModel
	
	var body: some View {
		TabView(selection: $model.selectedTab) {
			Button("Go to 2nd tab") {
				self.model.selectedTab = .inventory
			}
			.tabItem { Text("One") }
			.tag(Tab.one)
			
			NavigationStack {
				InventoryView(
					model: self.model.inventoryModel
				)
			}
			.tabItem { Text("Inventory") }
			.tag(Tab.inventory)
			
			Text("Three")
				.tabItem { Text("Three") }
				.tag(Tab.three)
		}
		.onOpenURL(perform: model.open)
	}
}

#Preview {
	MainView(
		model: MainModel(
			inventoryModel: InventoryModel(
				inventory: [
					ItemRowModel(item: Item(name: "Keyboard", color: .blue, status: .inStock(quantity: 100))),
					ItemRowModel(item: Item(name: "Charger", color: .yellow, status: .inStock(quantity: 20))),
					ItemRowModel(item: Item(name: "Phone", color: .white, status: .outOfStock(isOnBackOrder: true))),
					ItemRowModel(item: Item(name: "Headphones", color: .red, status: .outOfStock(isOnBackOrder: true)))
				]
			)
		)
	)
}
