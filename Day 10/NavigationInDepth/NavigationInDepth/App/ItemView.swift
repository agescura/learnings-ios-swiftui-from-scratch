//
//  ItemView.swift
//  NavigationInDepth
//
//  Created by Albert Gil on 6/10/24.
//

import SwiftUI

@Observable
class ItemModel: Identifiable, Hashable, Equatable {
	var item: Item
	var colorPickerIsPresented: Bool
	
	init(
		colorPickerIsPresented: Bool = false,
		item: Item
	) {
		self.colorPickerIsPresented = colorPickerIsPresented
		self.item = item
	}
	
	static func == (lhs: ItemModel, rhs: ItemModel) -> Bool {
		lhs.item == rhs.item
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(item)
	}
}

struct ItemView: View {
	@Bindable var model: ItemModel
	
	var body: some View {
		Form {
			TextField("Name", text: self.$model.item.name)
			
			Button {
				self.model.colorPickerIsPresented = true
			} label: {
				HStack {
					Text("Color")
					Spacer()
					
					if let color = self.model.item.color {
						Rectangle()
							.frame(width: 30, height: 30)
							.foregroundColor(color.swiftUIColor)
							.border(Color.black, width: 1)
					}
					Text(self.model.item.color?.name ?? "None")
						.foregroundColor(.gray)
						.frame(minWidth: 50)
				}
			}
			
			if case let .inStock(quantity) = self.model.item.status {
				Section(header: Text("In stock")) {
					Stepper(
						"Quantity: \(quantity)",
						value: Binding(
							get: { quantity },
							set: { newValue in
								self.model.item.status = .inStock(quantity: newValue)
							}
						)
					)
					Button("Mark as sold out") {
						self.model.item.status = .outOfStock(isOnBackOrder: false)
					}
				}
			}
			
			if case let .outOfStock(isOnBackOrder) = self.model.item.status {
				Section(header: Text("Out of stock")) {
					Toggle(
						"Is in back order?",
						isOn: Binding(
							get: { isOnBackOrder },
							set: { newValue in
								self.model.item.status = .outOfStock(isOnBackOrder: newValue)
							}
						)
					)
					Button("Is back in stock") {
						self.model.item.status = .inStock(quantity: 1)
					}
				}
			}
		}
		.navigationDestination(isPresented: self.$model.colorPickerIsPresented) {
			ColorPickerView(model: self.model)
		}
	}
}

#Preview {
	NavigationStack {
		ItemView(model: ItemModel(item: .new))
			.navigationTitle("Add Item")
	}
}

struct ColorPickerView: View {
	@Bindable var model: ItemModel
	@Environment(\.dismiss) var dismiss
	
	var body: some View {
		Form {
			Button {
				self.model.item.color = nil
				self.dismiss()
			} label: {
				HStack {
					Text("None")
					Spacer()
					if self.model.item.color == nil {
						Image(systemName: "checkmark")
					}
				}
			}
			
			Section(header: Text("Default colors")) {
				ForEach(Item.Color.defaults, id: \.self) { color in
					Button {
						self.model.item.color = color
						self.dismiss()
					} label: {
						HStack {
							Text(color.name)
							Spacer()
							if self.model.item.color == color {
								Image(systemName: "checkmark")
							}
						}
					}
				}
			}
			
		}
		.buttonStyle(.plain)
	}
}
