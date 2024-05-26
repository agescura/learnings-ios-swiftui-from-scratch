import Foundation

struct User: Identifiable, Equatable {
	let id: UUID = UUID()
	
	var name: String
	var username: String
	var country: Country
}

extension User {
	static var new = User(
		name: "",
		username: "",
		country: .empty
	)
}

extension Country {
	static var empty: Country {
		Country(flags: .init(png: ""), name: .init(common: "", official: ""))
	}
}

extension Array<User> {
	static var mocks: [User] = [
		User(name: "agescura", username: "Albert Gil", country: .empty),
		User(name: "micho", username: "Mauricio Gomez Gallo", country: .empty)
	]
}
