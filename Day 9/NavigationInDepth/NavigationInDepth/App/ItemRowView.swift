import Foundation
import SwiftUI

@Observable
class ItemRowModel: Identifiable {
	var item: Item
	var itemToDelete: Item?
	
	var onDeleteItem: () -> Void
	var onDuplicate: () -> Void
	
	init(
		item: Item,
		itemToDelete: Item? = nil,
		onDeleteItem: @escaping () -> Void = { fatalError() },
		onDuplicate: @escaping () -> Void = { fatalError() }
	) {
		self.item = item
		self.itemToDelete = itemToDelete
		self.onDeleteItem = onDeleteItem
		self.onDuplicate = onDuplicate
	}
	
	func alertButtonTapped() {
		self.itemToDelete = item
	}
	
	func dismissButtonTapped() {
		self.itemToDelete = nil
	}
}

struct ItemRowView: View {
	@Bindable var model: ItemRowModel
	
	var body: some View {
		HStack {
			VStack(alignment: .leading) {
				Text(self.model.item.name)
				
				switch self.model.item.status {
					case let .inStock(quantity):
						Text("In stock: \(quantity)")
					case let .outOfStock(isOnBackOrder):
						Text("Out of stock" + (isOnBackOrder ? ": on back order" : ""))
				}
			}
			
			Spacer()
			
			if let color = self.model.item.color {
				Rectangle()
					.frame(width: 30, height: 30)
					.foregroundColor(color.swiftUIColor)
					.border(Color.black, width: 1)
			}
			
			Button {
				self.model.alertButtonTapped()
			} label: {
				Image(systemName: "trash.fill")
			}
			.padding(.leading)
			
			Button {
				self.model.onDuplicate()
			} label: {
				Image(systemName: "square")
			}
			
			Button {
//				self.model.editButtonTapped(item)
			} label: {
				Image(systemName: "arrow.forward")
			}
		}
		.buttonStyle(.plain)
		.foregroundColor(self.model.item.status.isInStock ? nil : Color.gray)
		.alert(
			title: { Text($0.name) },
			presenting: self.$model.itemToDelete,
			actions: { itemToDelete in
				Button(
					"Delete",
					role: .destructive,
					action: { self.model.onDeleteItem() }
				)
				Button("Cancel", role: .cancel) { self.model.dismissButtonTapped() }
			},
			message: { itemToDelete in
				Text("Are you sure you want to delete the \(itemToDelete.name)")
			}
		)
	}
}

#Preview {
	NavigationStack {
		List {
			ItemRowView(
				model: ItemRowModel(
					item: Item(
						id: UUID(uuidString: "d6d98b88-c866-4496-9bd4-de7ba48d0f52")!,
						name: "Keyboard",
						color: .blue,
						status: .inStock(quantity: 100)
					)
				)
			)
		}
	}
}
