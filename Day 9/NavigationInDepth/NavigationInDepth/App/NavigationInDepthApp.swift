import SwiftUI

@main
struct NavigationInDepthApp: App {
    
    var body: some Scene {
        WindowGroup {
            MainView(
                model: MainModel(
                    inventoryModel: InventoryModel(
                        inventory: []
                    )
                )
            )
        }
    }
}
