//
//  ItemView.swift
//  NavigationInDepth
//
//  Created by Albert Gil on 6/10/24.
//

import SwiftUI

struct ItemView: View {
	@State var item: Item
	
	var cancel: () -> Void
	var add: (Item) -> Void
	var edit: (Item) -> Void
	
	init(
		item: Item,
		cancel: @escaping () -> Void,
		add: @escaping (Item) -> Void = { _ in },
		edit: @escaping (Item) -> Void = { _ in }
	) {
		self.item = item
		self.cancel = cancel
		self.add = add
		self.edit = edit
	}
	
	var body: some View {
		Form {
			TextField("Name", text: self.$item.name)
			
			Picker(selection: self.$item.color, label: Text("Color")) {
				Text("None")
					.tag(Item.Color?.none)
				
				ForEach(Item.Color.defaults, id: \.name) { color in
					Text(color.name)
						.tag(Optional(color))
				}
			}
		}
		.toolbar {
			ToolbarItem(placement: .cancellationAction) {
				Button("Cancel") {
					self.cancel()
				}
			}
			ToolbarItem(placement: .primaryAction) {
				Button("Add") {
					self.add(item)
				}
			}
		}
	}
}

#Preview {
	NavigationStack {
		ItemView(
			item: .new,
			cancel: {},
			add: { _ in }
		)
	}
}
