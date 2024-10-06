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
        inventory: [Item] = []
    ) {
        self.inventory = inventory
    }
    
//    @inlinable public func firstIndex(where predicate: (Element) throws -> Bool) rethrows -> Int?
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
                .alert(
                    item.name,
                    isPresented: self.$model.itemToDelete.isPresent()
                ) {
                    Button(
                        "Delete",
                        role: .destructive,
                        action: { self.model.deleteItemButtonTapped(item: item) }
                    )
                    Button("Cancel", role: .cancel) { self.model.dismissButtonTapped() }
                }
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
            isPresented: self.$model.itemToAdd.isPresent()
        ) {
            ItemView(item: .constant(.new))
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
