//
//  Item.swift
//  NavigationInDepth
//
//  Created by Albert Gil on 6/10/24.
//

import Foundation
import SwiftUI

struct Item: Equatable, Identifiable, Hashable {
	let id: UUID
	var name: String
	var color: Color?
	var status: Status
	
	init(
		id: UUID = UUID(),
		name: String,
		color: Color? = nil,
		status: Status
	) {
		self.id = id
		self.name = name
		self.color = color
		self.status = status
	}
	
	enum Status: Equatable, Hashable {
		case inStock(quantity: Int)
		case outOfStock(isOnBackOrder: Bool)
		
		var isInStock: Bool {
			guard case .inStock = self else { return false }
			return true
		}
	}
	
	struct Color: Equatable, Hashable {
		var name: String
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		
		static var defaults: [Self] = [
			.red,
			.green,
			.blue,
			.black,
			.yellow,
			.white,
		]
		
		static let red = Self(name: "Red", red: 1)
		static let green = Self(name: "Green", green: 1)
		static let blue = Self(name: "Blue", blue: 1)
		static let black = Self(name: "Black")
		static let yellow = Self(name: "Yellow", red: 1, green: 1)
		static let white = Self(name: "White", red: 1, green: 1, blue: 1)
		
		var swiftUIColor: SwiftUI.Color {
			.init(red: self.red, green: self.green, blue: self.blue)
		}
	}
	
	static let new = Item(name: "", status: .inStock(quantity: 1))
}
