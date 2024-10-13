import SwiftUI

@main
struct NavigationInDepthApp: App {
	let item = Item(
		id: UUID(uuidString: "d6d98b88-c866-4496-9bd4-de7ba48d0f52")!,
		name: "Keyboard",
		color: .blue,
		status: .inStock(quantity: 100)
	)
	
	var body: some Scene {
		WindowGroup {
			MainView(
				model: MainModel(
					inventoryModel: InventoryModel(
						inventory: [
							item,
							Item(name: "Charger", color: .yellow, status: .inStock(quantity: 20)),
							Item(name: "Phone", color: .white, status: .outOfStock(isOnBackOrder: true)),
							Item(name: "Headphones", color: .red, status: .outOfStock(isOnBackOrder: true))
						],
						itemToDelete: nil,
						itemToAdd: nil
					)
				)
			)
		}
	}
}
