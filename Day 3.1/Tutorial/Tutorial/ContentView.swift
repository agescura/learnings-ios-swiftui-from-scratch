
import SwiftUI

// Si tenemos un trozo de código que representa algo en concreto, es mejor crear un objeto que encapsule exactamente esto. Por ejemplo, la celda que pintaremos cada uno de los usuarios
// Te dejo este codigo para que lo reemplaces en ContentView

struct UserRowView: View {
	let user: User
	
	var body: some View {
		VStack (
				alignment: .leading
		) {
				HStack{
						Image(
								systemName: "person"
						)
						.imageScale(
								.large
						)
						.foregroundStyle(
								.tint
						)
						Text(
								user.userName
						)
				}
				HStack{
						Image(
								systemName: "globe"
						)
						.imageScale(.large)
						.foregroundStyle(.tint)
						Text(user.nickName)
				}
				HStack{
						Image(
								systemName: "number"
						)
						.imageScale(
								.large
						)
						.foregroundStyle(
								.tint
						)
						Text(
								user.phoneNumber
						)
				}
		}
	}
}

struct ContentView: View {
    
    @Bindable var model: ContentModel = ContentModel()
    
    var body: some View {
        NavigationStack{
            
            List{
                ForEach(
                    self.model.listUsers
                ) { user in
                    VStack (
                        alignment: .leading
                    ) {
                        HStack{
                            Image(
                                systemName: "person"
                            )
                            .imageScale(
                                .large
                            )
                            .foregroundStyle(
                                .tint
                            )
                            Text(
                                user.userName
                            )
                        }
                        HStack{
                            Image(
                                systemName: "globe"
                            )
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                            Text(user.nickName)
                        }
                        HStack{
                            Image(
                                systemName: "number"
                            )
                            .imageScale(
                                .large
                            )
                            .foregroundStyle(
                                .tint
                            )
                            Text(
                                user.phoneNumber
                            )
                        }
                    }
                }
            }
            .navigationTitle(
                self.model.titulo
            )
            .toolbar{
                ToolbarItem(
                    placement: .primaryAction
                ){
                    Button(action: {
                        print(
                            self.model.addUserIsPresented
                        )
                        
											// Aquí deberias usar una función y encapsular este codigo dentro de la función en el modelo.
											// Recuerda que toda lógica que tengas en la vista, es codigo que no vas a poder testear
											
                        self.model.userToAdd = User(
                            userName: "",
                            nickName: "",
                            phoneNumber: ""
                        )
                        
                        self.model.addUserIsPresented = true
                    },
                           label: {
                        Text(
                            "add user"
                        )
                    })
                }
            }
            .sheet(
                isPresented: self.$model.addUserIsPresented,
                content: {
                    NavigationStack{
                        ZStack{
                            
                            VStack{
                                Form {
                                    Section(
                                        header: Text(
                                            "Name"
                                        )
                                    ) {
                                        TextField(
                                            "Name",
                                            text: Binding<String>(get: {
                                                self.model.userToAdd?.userName ?? ""
                                            },
                                                                  set: { updatedUserName in
                                                                      self.model.userToAdd?.userName = updatedUserName
                                                                  })
                                        )
                                    }
                                    /*    Section(header: Text("Nick name")) {
                                     TextField("Nick name", text: self.$model.userToAdd?.nickName)
                                     }
                                     Section(header: Text("hone number")) {
                                     TextField("Phone number", text: self.$model.userToAdd.phoneNumber)
                                     }*/
                                    
                                }
                            }
                        }
                        .toolbar{
                            ToolbarItem(
                                placement: .primaryAction
                            ) {
                                Button(action: {
                                    print(
                                        self.model.userToAdd
                                    )
                                    self.model.addUserToList()
                                    self.model.addUserIsPresented = false
                                    
                                },
                                       label: {
                                    Text(
                                        "add"
                                    )
                                    })
                                }
                            }
                    }
                    
                    
                
            })
        }
    }
}

@Observable
class ContentModel {
    var addUserIsPresented: Bool
    var listUsers: [User]
    
    var userToAdd: User?
    //= User(userName: "", nickName: "", phoneNumber: "")
    
    init(
        addUserIsPresented: Bool = false,
        listUsers: [User] = []
    ) {
        self.addUserIsPresented = addUserIsPresented
        self.listUsers = listUsers
    }
    
    func addUserToList(){
        //self.listUsers.append(userToAdd)
        
        if let userToAdd {
            self.listUsers.append(
                userToAdd
            )
        }
        
          
    }

    let titulo = "titulo"
}

struct User: Identifiable {
    let id: UUID = UUID()
    var userName: String
    var nickName: String
    var phoneNumber: String
}










#Preview {
    
    ContentView(
        model: ContentModel(
            addUserIsPresented: false,
            listUsers: [
                User(
                    userName: "Mauricio",
                    nickName: "MAO",
                    phoneNumber: "5555555"
                ),
                User(
                    userName: "Marcela",
                    nickName: "Marce",
                    phoneNumber: "5555555"
                ),
                User(
                    userName: "Diego",
                    nickName: "DIE",
                    phoneNumber: "5555555"
                )   ]
        )
    )
}




func hola() {
    let foo: Binding<String>
    
    let foo2: Binding<String>?
    
    let foo3: Binding<String?>
    
    let foo4: Binding<String?>?
    
    let foo5: String = "Titulo5"
    
    let foo6: String? = "Titulo6"
    
}

enum Opcional <T> {
    case some(T)
    case none
}
