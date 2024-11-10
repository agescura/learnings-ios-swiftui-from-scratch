import Foundation
import SwiftUI
import SwiftUINavigation

@Observable
class ItemRowModel: Identifiable {
	var item: Item
	var route: Route?
	
	@CasePathable
	enum Route {
		case delete
		case edit(ItemModel)
	}
	
	var onDeleteItem: () -> Void
	var onDuplicate: () -> Void
	var onEditItem: (Item) -> Void
	
	init(
		item: Item,
		route: Route? = nil,
		onDeleteItem: @escaping () -> Void = { fatalError() },
		onDuplicate: @escaping () -> Void = { fatalError() },
		onEditItem: @escaping (Item) -> Void = { _ in fatalError() }
	) {
		self.item = item
		self.route = route
		self.onDeleteItem = onDeleteItem
		self.onDuplicate = onDuplicate
		self.onEditItem = onEditItem
	}
	
	func alertButtonTapped() {
		self.route = .delete
	}
	
	func deleteButtonTapped() {
		self.onDeleteItem()
	}
	
	func dismissButtonTapped() {
		self.route = nil
	}
	
	func duplicateButtonTapped() {
		self.onDuplicate()
	}
	
	func editButtonTapped() {
		self.route = .edit(ItemModel(item: item))
	}
	
	func updateButtonTapped(_ item: Item) {
		self.onEditItem(item)
		self.route = nil
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
				self.model.duplicateButtonTapped()
			} label: {
				Image(systemName: "square")
			}
			
			Button {
				self.model.editButtonTapped()
			} label: {
				Image(systemName: "arrow.forward")
			}
		}
		.buttonStyle(.plain)
		.foregroundColor(self.model.item.status.isInStock ? nil : Color.gray)
		.alert(
			item: self.$model.route.delete,
			title: { _ in
				Text(self.model.item.name)
			},
			actions: { _ in
				Button(
					"Delete",
					role: .destructive,
					action: { self.model.deleteButtonTapped() }
				)
				Button("Cancel", role: .cancel) { self.model.dismissButtonTapped() }
			},
			message: { _ in
				Text("Are you sure you want to delete the \(self.model.item.name)")
			}
		)
		.navigationDestination(
			item: self.$model.route.edit
		) { itemToEdit in
			ItemView(model: itemToEdit)
				.navigationTitle("Edit item")
				.navigationBarBackButtonHidden()
				.toolbar {
					ToolbarItem(placement: .cancellationAction) {
						Button("Cancel") {
							self.model.dismissButtonTapped()
						}
					}
					ToolbarItem(placement: .primaryAction) {
						Button("Update") {
							self.model.updateButtonTapped(itemToEdit.item)
						}
					}
				}
		}
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
