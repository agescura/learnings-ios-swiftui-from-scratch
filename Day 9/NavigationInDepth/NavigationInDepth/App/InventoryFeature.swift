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
	var itemToAdd: ItemModel?
    var itemToEdit: Item?
	
	init(
		inventory: [Item] = [],
		itemToDelete: Item? = nil,
		itemToAdd: ItemModel? = nil,
        itemToEdit: Item? = nil
	) {
		self.inventory = inventory
		self.itemToDelete = itemToDelete
		self.itemToAdd = itemToAdd
        self.itemToEdit = itemToEdit
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
		self.itemToAdd = nil
		self.itemToEdit = nil
	}
	
	func addItemButtonTapped() {
		self.itemToAdd = ItemModel(item: .new)
	}
	
	func confirmAddButtonTapped(_ item: Item) {
		withAnimation {
			self.inventory.append(item)
		}
		self.itemToAdd = nil
	}
    
    func editButtonTapped(_ item: Item) {
        self.itemToEdit = item
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
                    
                    Button {
                        self.model.editButtonTapped(item)
                    } label: {
                        Image(systemName: "arrow.forward")
                    }
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
			title: { Text($0.name) },
			presenting: self.$model.itemToDelete,
			actions: { itemToDelete in
				Button(
					"Delete",
					role: .destructive,
					action: { self.model.deleteItemButtonTapped(item: itemToDelete) }
				)
				Button("Cancel", role: .cancel) { self.model.dismissButtonTapped() }
			},
			message: { itemToDelete in
				Text("Are you sure you want to delete the \(itemToDelete.name)")
			}
		)
        .sheet(
            unwrap: self.$model.itemToAdd
        ) { $itemToAdd in
            NavigationStack {
                ItemView(model: itemToAdd)
                    .navigationTitle("Add new item")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                self.model.dismissButtonTapped()
                            }
                        }
                        ToolbarItem(placement: .primaryAction) {
                            Button("Add") {
								self.model.confirmAddButtonTapped(itemToAdd.item)
                            }
                        }
                    }
            }
        }
//        .navigationDestination(
//            unwrap: self.$model.itemToEdit
//        ) { $itemToEdit in
//			ItemView(item: $itemToEdit)
//                .navigationTitle(itemToEdit.name)
//        }
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

//#Preview {
//    TestStateBinding()
//}

struct TestStateBinding: View {
    @State var miEstado: Int = 3
    
    var body: some View {
        Text("Test")
        Text("\(miEstado)")
        Button("Cambiar estado") {
            miEstado += 1
        }
        
        TestBinding(miOtroEstado: $miEstado)
    }
}

struct TestBinding: View {
    @Binding var miOtroEstado: Int
    
    var body: some View {
        Text("\(miOtroEstado)")
        Button("Cambiar mi otro estado") {
            miOtroEstado += 1
        }
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

extension Binding {
  init?(unwrap binding: Binding<Value?>) {
	guard let wrappedValue = binding.wrappedValue
	else { return nil }
	
	self.init(
	  get: { wrappedValue },
	  set: { binding.wrappedValue = $0 }
	)
  }
}

extension View {
  func sheet<Value, Content>(
	unwrap optionalValue: Binding<Value?>,
	@ViewBuilder content: @escaping (Binding<Value>) -> Content
  ) -> some View where Value: Identifiable, Content: View {
	self.sheet(
	  item: optionalValue
	) { _ in
	  if let value = Binding(unwrap: optionalValue) {
		content(value)
	  }
	}
  }
}

extension View {
    func navigationDestination<Value, Content>(
        unwrap optionalValue: Binding<Value?>,
        @ViewBuilder content: @escaping (Binding<Value>) -> Content
    ) -> some View where Value: Hashable, Content: View {
        self.navigationDestination(
            item: optionalValue
        ) { _ in
            if let value = Binding(unwrap: optionalValue) {
                content(value)
            }
        }
    }
}

extension View {
	func alert<A: View, M: View, T>(
		title: (T) -> Text,
		presenting data: Binding<T?>,
		@ViewBuilder actions: @escaping (T) -> A,
		@ViewBuilder message: @escaping (T) -> M
	) -> some View {
		self.alert(
			data.wrappedValue.map(title) ?? Text(""),
			isPresented: data.isPresent(),
			presenting: data.wrappedValue,
			actions: actions,
			message: message
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
