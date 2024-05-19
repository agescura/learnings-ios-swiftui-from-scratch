import Foundation

struct Country: Identifiable, Decodable, Equatable, Hashable {
	let flags: Flags
	let name: Name
	
	struct Name: Decodable, Equatable, Hashable {
		let common: String
		let official: String
	}
	
	struct Flags: Decodable, Equatable, Hashable {
		let png: String
	}
	
	var id: String {
		self.name.official
	}
}
