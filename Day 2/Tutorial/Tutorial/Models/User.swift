import Foundation

struct User: Identifiable {
	let id: UUID = UUID()
	
	var name: String
	var username: String
	var country: String
}

extension User {
	static var new = User(
		name: "",
		username: "",
		country: ""
	)
}

extension Array<User> {
	static var mocks: [User] = [
		User(name: "agescura", username: "Albert Gil", country: "Spain"),
		User(name: "micho", username: "Mauricio Gomez Gallo", country: "Colombia")
	]
}
