import SwiftUI

// Patron MVVM, MV
// Model View ViewModel
// Model View

@Observable
class AddUserModel {
	var user: User
	
	init(
		user: User
	) {
		self.user = user
	}
}

struct AddUserView: View {
	@Bindable var model: AddUserModel
	
	var body: some View {
		Form {
			Section(header: Text("Write a name")) {
				TextField("Name", text: self.$model.user.name)
			}
			.textCase(nil)
			Section(header: Text("Username")) {
				TextField("Username", text: self.$model.user.username)
			}
			.textCase(nil)
		}
	}
}

struct User: Identifiable {
	let id: UUID = UUID()
	
	var name: String
	var username: String
}

@Observable
class ContentModel {
	var addUserIsPresented: Bool
	var addUserModel: AddUserModel?
	var users: [User]
	
	init(
		addUserIsPresented: Bool = false,
		users: [User] = []
	) {
		self.addUserIsPresented = addUserIsPresented
		self.users = users
	}
	
	func addUserButtonTapped() {
		self.addUserModel = AddUserModel(
			user: User(name: "", username: "")
		)
		self.addUserIsPresented = true
	}
	
	func cancelButtonTapped() {
		self.addUserIsPresented = false
		self.addUserModel = nil
	}
	func confirmAddUserButtonTapped() {
		if let addUserModel = self.addUserModel {
			self.users.append(
				addUserModel.user
			)
		}
		self.addUserIsPresented = false
		self.addUserModel = nil
	}
}

struct ContentView: View {
	@Bindable var model: ContentModel = ContentModel()
	
	var body: some View {
		List {
			ForEach(self.model.users) { user in
				VStack(alignment: .leading, spacing: 8) {
					Text(user.name)
						.font(.title3)
					Text(user.username)
						.font(.caption)
				}
			}
		}
		.navigationTitle("Contactos")
		.toolbar {
			ToolbarItem(placement: .primaryAction) {
				Button(
					action: {
						self.model.addUserButtonTapped()
					},
					label: { Image(systemName: "plus") }
				)
			}
		}
		.sheet(
			isPresented: self.$model.addUserIsPresented
		) {
			if let addUserModel = self.model.addUserModel {
				NavigationStack {
					AddUserView(model: addUserModel)
						.navigationTitle("Add User")
						.navigationBarTitleDisplayMode(.inline)
						.toolbar {
							ToolbarItem(placement: .cancellationAction) {
								Button("Cancel") {
									self.model.cancelButtonTapped()
								}
							}
							ToolbarItem(placement: .primaryAction) {
								Button("Add user") {
									self.model.confirmAddUserButtonTapped()
								}
							}
						}
				}
			}
		}
	}
}

#Preview {
	NavigationStack {
		ContentView(
			model: ContentModel(
				addUserIsPresented: false,
				users: [
					User(name: "agescura", username: "Albert Gil"),
					User(name: "micho", username: "Mauricio Gomez Gallo")
				]
			)
		)
	}
}



// lenguajes OO -> interfaz
// swift 				-> protocolo

protocol Auto {
	func consumo() -> Int
}

func foo() {
	
	struct Moto: Auto {
		func consumo() -> Int {
			return c
		}
		
		let c = 5
	}
	
	struct Coche: Auto {
		func consumo() -> Int {
			return c
		}
		
		let c = 20
	}
	
	
	let moto1 = Moto()
	let coche1 = Coche()
	
	var parking: [Auto] = [
		moto1,
		coche1
	]
	
	print(type(of: moto1))
	print(type(of: parking[1]))
	
	if let coche = parking[1] as? Moto {
		print("Hay un coche")
		
		
		
		
		
	} else {
		print("No hay un coche")
	}
	
	// no existe coche
	
	struct Avion: Auto {
		func consumo() -> Int {
			return 100
		}
	}
	
	let avion1 = Avion()
	
	parking.append(avion1)
	
	
	// Principio Open Close
	// Abierto para iterar, para agregar
	// Cerrado para modificar
	
	class Clase {
		var valor: Int
		
		init(
			valor: Int
		) {
			self.valor = valor
		}
		
		deinit {
			
		}
	}
	
	struct Estructura {
		var valor: Int
		
		mutating func changeValue(valor: Int) {
			self.valor = valor
		}
	}
	
	
	
	// UNa clase tiene que tener INIT
	
	
	let clase1 = Clase(valor: 1)
	var estructura1 = Estructura(valor: 2)
	
	print(clase1.valor)
	print(estructura1.valor)
	
	clase1.valor = 2
	estructura1.valor = 1
	
	estructura1.changeValue(valor: 1)
	estructura1 = Estructura(valor: 1)
	estructura1.valor = 1
	
	let clase2 = clase1
	clase2.valor = 10
	
	print(clase1.valor)
}




