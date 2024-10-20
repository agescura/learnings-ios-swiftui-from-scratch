//
//  ItemView.swift
//  NavigationInDepth
//
//  Created by Albert Gil on 6/10/24.
//

import SwiftUI

struct ItemView: View {
	@Binding var item: Item
	
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
	}
}

#Preview {
	NavigationStack {
		ItemView(
            item: .constant(.new)
		)
	}
}
