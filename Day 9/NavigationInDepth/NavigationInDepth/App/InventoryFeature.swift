//
//  Inventory.swift
//  NavigationInDepth
//
//  Created by Albert Gil on 6/10/24.
//

import Foundation
import SwiftUI

@Observable
class InventoryModel {
	var inventory: [ItemRowModel]
	var itemToAdd: ItemModel?
    var itemToEdit: ItemModel?
	var dismissAlert: Bool = false
	
	init(
		inventory: [ItemRowModel] = [],
		itemToAdd: ItemModel? = nil,
        itemToEdit: ItemModel? = nil
	) {
		self.inventory = []
		self.itemToAdd = itemToAdd
        self.itemToEdit = itemToEdit

		for itemRowModel in inventory {
			self.bind(itemRowModel: itemRowModel)
		}
	}
	
	private func bind(itemRowModel: ItemRowModel) {
		itemRowModel.onDeleteItem = { [weak self, item = itemRowModel.item] in
			guard let self else { return }
			self.deleteItemButtonTapped(item: item)
		}
		itemRowModel.onDuplicate = { [weak self, item = itemRowModel.item] in
			guard let self else { return }
			self.duplicateTapped(item)
		}
		self.inventory.append(itemRowModel)
	}
	
	func deleteItemButtonTapped(item: Item) {
		guard
			let index = self.inventory.firstIndex(where: { $0.item.id == item.id })
		else { return }
		_ = withAnimation {
			self.inventory.remove(at: index)
		}
	}
	
	func dismissButtonTapped() {
		self.itemToAdd = nil
		self.itemToEdit = nil
		self.dismissAlert = false
	}
	
	func popButtonTapped(_ item: Item) {
		guard
			let index = self.inventory.firstIndex(where: { $0.item.id == item.id })
		else { return }
		
		if self.inventory[index].item != item {
			self.dismissAlert = true
		} else {
			self.itemToAdd = nil
			self.itemToEdit = nil
			self.dismissAlert = false
		}
	}
	
	func addItemButtonTapped() {
		self.itemToAdd = ItemModel(item: .new)
	}
	
	func confirmAddButtonTapped(_ item: Item) {
		withAnimation {
			self.inventory.append(ItemRowModel(item: item))
		}
		self.itemToAdd = nil
	}
    
    func editButtonTapped(_ item: Item) {
        self.itemToEdit = ItemModel(item: item)
    }
	
	func updateButtonTapped(_ item: Item) {
		guard
			let index = self.inventory.firstIndex(where: { $0.item.id == item.id })
		else { return }
		self.inventory[index].item = item
		self.itemToEdit = nil
	}
	
	func duplicateTapped(_ item: Item) {
		withAnimation {
			self.inventory.append(ItemRowModel(item:item))
		}
	}
}

struct InventoryView: View {
	@Bindable var model: InventoryModel
    
	var body: some View {
		List {
			ForEach(self.model.inventory) { itemRowModel in
				ItemRowView(model: itemRowModel)
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
        .navigationDestination(
            unwrap: self.$model.itemToEdit
        ) { $itemToEdit in
			ItemView(model: itemToEdit)
				.navigationTitle(itemToEdit.item.name)
				.navigationBarBackButtonHidden()
				.toolbar {
					ToolbarItem(placement: .cancellationAction) {
						Button("Cancel") {
							self.model.popButtonTapped(itemToEdit.item)
						}
					}
					ToolbarItem(placement: .primaryAction) {
						Button("Update") {
							self.model.updateButtonTapped(itemToEdit.item)
						}
					}
				}
        }
		.alert(
			"Do you want to dismiss?",
			isPresented: self.$model.dismissAlert,
			actions: {
				Button(
					"Dismiss",
					role: .cancel,
					action: {
						self.model.dismissAlert = false
						self.model.itemToEdit = nil
					}
				)
				Button("Cancel") { self.model.dismissAlert = false }
			}
		)
	}
}

#Preview {
	NavigationStack {
		InventoryView(
			model: InventoryModel(
				inventory: [
					ItemRowModel(item: Item(name: "Keyboard", color: .blue, status: .inStock(quantity: 100))),
					ItemRowModel(item: Item(name: "Charger", color: .yellow, status: .inStock(quantity: 20))),
					ItemRowModel(item: Item(name: "Phone", color: .white, status: .outOfStock(isOnBackOrder: true))),
					ItemRowModel(item: Item(name: "Headphones", color: .red, status: .outOfStock(isOnBackOrder: true)))
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



