//
//  Inventory.swift
//  NavigationInDepth
//
//  Created by Albert Gil on 6/10/24.
//

import Foundation
import SwiftUI

// Make impossible states impossble

enum Route {
	case delete(Item)
	case add(Item)
	case edit(Item)
}

@Observable
class InventoryModel {
	var inventory: [Item]
	var itemToDelete: Item?
	var itemToAdd: Item?
	
	init(
		inventory: [Item] = [],
		itemToDelete: Item? = nil,
		itemToAdd: Item? = nil
	) {
		self.inventory = inventory
		self.itemToDelete = itemToDelete
		self.itemToAdd = itemToAdd
	}
	
	func deleteItemButtonTapped(item: Item) {
		guard
			let index = self.inventory.firstIndex(where: { $0.id == item.id })
		else { return }
		_ = withAnimation {
			self.inventory.remove(at: index)
		}
	}
	
	func alertButtonTapped(item: Item) {
		self.itemToDelete = item
	}
	
	func dismissButtonTapped() {
		self.itemToDelete = nil
	}
	
	func addItemButtonTapped() {
		self.itemToAdd = .new
	}
	
	func cancelButtonTapped() {
		self.itemToAdd = nil
	}
	
	func confirmAddButtonTapped(_ item: Item) {
		self.inventory.append(item)
		self.itemToAdd = nil
	}
}

struct InventoryView: View {
	@Bindable var model: InventoryModel
	
	var body: some View {
		List {
			ForEach(self.model.inventory) { item in
				HStack {
					VStack(alignment: .leading) {
						Text(item.name)
						
						switch item.status {
							case let .inStock(quantity):
								Text("In stock: \(quantity)")
							case let .outOfStock(isOnBackOrder):
								Text("Out of stock" + (isOnBackOrder ? ": on back order" : ""))
						}
					}
					
					Spacer()
					
					if let color = item.color {
						Rectangle()
							.frame(width: 30, height: 30)
							.foregroundColor(color.swiftUIColor)
							.border(Color.black, width: 1)
					}
					
					Button(action: { self.model.alertButtonTapped(item: item) }) {
						Image(systemName: "trash.fill")
					}
					.padding(.leading)
				}
				.buttonStyle(.plain)
				.foregroundColor(item.status.isInStock ? nil : Color.gray)
			}
		}
		.navigationTitle("Inventory")
		.toolbar {
			ToolbarItem(placement: .primaryAction) {
				Button("Add") {
					self.model.addItemButtonTapped()
				}
			}
		}
		.alert(
			self.model.itemToDelete?.name ?? "",
			isPresented: self.$model.itemToDelete.isPresent(),
			presenting: self.model.itemToDelete
		) { itemToDelete in
			Button(
				"Delete",
				role: .destructive,
				action: { self.model.deleteItemButtonTapped(item: itemToDelete) }
			)
			Button("Cancel", role: .cancel) { self.model.dismissButtonTapped() }
		}
		.sheet(
			isPresented: self.$model.itemToAdd.isPresent()
		) {
			if let itemToAdd = self.model.itemToAdd {
				NavigationStack {
					ItemView(
						item: itemToAdd,
						cancel: { self.model.cancelButtonTapped() },
						add: { item in
							self.model.confirmAddButtonTapped(item)
						}
					)
					.navigationTitle("Add new item")
				}
			}
		}
	}
}

#Preview {
	NavigationStack {
		InventoryView(
			model: InventoryModel(
				inventory: [
					Item(name: "Keyboard", color: .blue, status: .inStock(quantity: 100)),
					Item(name: "Charger", color: .yellow, status: .inStock(quantity: 20)),
					Item(name: "Phone", color: .white, status: .outOfStock(isOnBackOrder: true)),
					Item(name: "Headphones", color: .red, status: .outOfStock(isOnBackOrder: true))
				]
			)
		)
	}
}

extension Binding {
	func isPresent<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
		.init(
			get: { self.wrappedValue != nil },
			set: { isPresented in
				if !isPresented {
					self.wrappedValue = nil
				}
			}
		)
	}
}

/*
 Navigation
 
 TabView
 
 Alerts
 ConfirmationDialog
 
 Sheets
 FullScreenCover
 Popover
 
 Links
 */
