import SwiftUI

enum Tab {
	case search, home, settings
}

struct AppView: View {
	@State var tab: Tab = .search
	
	var body: some View {
		TabView(selection: self.$tab) {
			SearchView()
				.tabItem { Text("Search") }
				.tag(Tab.search)
			HomeView(model: HomeModel())
				.tabItem { Text("Home") }
				.tag(Tab.home)
			SettingsView()
				.tabItem { Text("Settings") }
				.tag(Tab.settings)
		}
	}
}

#Preview {
	NavigationStack {
		Button("Continue") {
			
		}
		.buttonStyle(CustomButtonStyle())
		.padding()
		.disabled(true)
		
		Button(role: .destructive) {
			
		} label: {
			Label("Delete", systemImage: "trash")
		}
		.buttonStyle(CustomButtonStyle())
		.padding()
		.disabled(true)
	}
}

struct MyButton<Label: View>: View {
	var action: () -> Void
	var label: Label
	
	init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
		self.action = action
		self.label = label()
	}
	
	var body: some View {
		Button {
			action()
		} label: {
			HStack {
				Spacer()
				label
				Spacer()
			}
			.padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
		}
		.font(.system(.title2, design: .rounded, weight: .bold))
		.foregroundColor(.yellow)
		.background(Capsule().stroke(.yellow, lineWidth: 2))
	}
}

extension MyButton where Label == Text {
	@_disfavoredOverload
	init(_ title: some StringProtocol, role: ButtonRole? = nil, action: @escaping () -> Void) {
		self.action = action
		self.label = Text(title)
	}
	
	init(_ titleKey: LocalizedStringKey, role: ButtonRole? = nil, action: @escaping () -> Void) {
		self.action = action
		self.label = Text(titleKey)
	}
}

struct CustomButtonStyle: ButtonStyle {
	@Environment(\.isEnabled) var isEnabled
	
	func makeBody(configuration: Configuration) -> some View {
		HStack {
			Spacer()
			configuration.label
			Spacer()
		}
		.padding(EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24))
		.font(.system(.title2, design: .rounded).bold())
		.foregroundColor(configuration.role == .destructive ? .red : .yellow)
		.background {
			Capsule()
				.stroke(configuration.role == .destructive ? .red : .yellow, lineWidth: 2)
		}
		.opacity(configuration.isPressed ? 0.5 : 1)
		.saturation(isEnabled ? 1 : 0)
	}
}


enum Gender: String, CaseIterable {
	case male, female
}

// Gender.male
// Gender.female

// Gender?

// Gender.some(male)
// Gender.some(female)
// Gender.none


struct User {
	var name: String
	var gender: Gender?
}

struct FormView: View {
	@State var user: User = User(name: "")
	
	var disabledForm: Bool {
		self.user.name.count < 4
	}
	
	var body: some View {
		VStack {
			Form {
				Section {
					Button("Continuar") {}
				}
				Section {
					TextField("Placeholder", text: self.$user.name)
				} header: {
					Text("Password")
				} footer: {
					Text("Your password must be 8-20 characters long, contain letters and numbers, and must not contain spaces, special characters, or emoji.")
				}
				.textCase(.lowercase)
				
				Section {
					TextField("Placeholder", text: self.$user.name)
					TextField("Placeholder", text: self.$user.name)
				} header: {
					Text("Password")
				} footer: {
					Text("Your password must be 8-20 characters long, contain letters and numbers, and must not contain spaces, special characters, or emoji.")
				}
			}
		}
		
//		Picker("Gender", selection: self.$user.gender) {
//			Text("No seleccionado")
//				.tag(Gender?.none)
//			ForEach(Gender.allCases, id: \.self) { gender in
//				Text(gender.rawValue)
//					.tag(Optional(gender))
//			}
//		}
//		.pickerStyle(.navigationLink)
//		Text("You selected: \(self.user.gender!.rawValue)")
	}
}


struct SearchView: View {
	@Namespace var namespace
	@Environment(\.isFocused) var isFocused
	@State var isCollapse = false
	
	var body: some View {
		ZStack {
			VStack {
				Spacer()
				Button {
					
				} label: {
					Text("Contenido")
				}
				Spacer()
			}
//			.focusSection()
//			.prefersDefaultFocus(in: namespace)
			HStack {
				VStack(alignment: .leading) {
					Spacer()
					ZStack {
						PosterView(title: "Home", isCollapse: self.isCollapse)
					}
					.focusable()
					ZStack {
						PosterView(title: "Series", isCollapse: self.isCollapse)
					}
					.focusable()
					ZStack {
						PosterView(title: "Pelis", isCollapse: self.isCollapse)
					}
					.focusable()
					ZStack {
						PosterView(title: "Videos", isCollapse: self.isCollapse)
					}
					.focusable()
					Spacer()
				}
				Spacer()
			}
//			.ignoresSafeArea()
//			.focusSection()
		}
//		.focusScope(namespace)
	}
}

struct PosterView: View {
	@Environment(\.isFocused) var isFocused
	let title: String
	let isCollapse: Bool
	
	var body: some View {
		ZStack {
			RoundedRectangle(cornerRadius: 8)
				.frame(width: isCollapse ? 50 : 150)
				.scaleEffect(isFocused ? 1.2 : 1)
				.animation(.easeInOut, value: isFocused)
			HStack(spacing: 0) {
				Image(systemName: "globe")
				if !self.isCollapse {
					Text(title)
				}
			}
			.foregroundColor(.black)
		}
	}
}

struct SettingsView: View {
	@Namespace var namespace
	
	var body: some View {
		VStack {
			HStack {
				Spacer()
				Button("Login") {}
				Spacer()
			}
//			.focusSection()
			HStack {
				Button("Legales") {}
				Button("Privacidad") {}
			}
//			.focusScope(self.namespace)
//			.focusSection()
		}
//		.onMoveCommand() { (direction) in
//			print("Moved!")
//		}
		
	}
}


func a(first: String, second: String) -> String {
	first + second
}

func a(first: Int, second: Int) -> Int {
	first + second
}
//  operand: (T           , T             ) -> T <= funcion anonima // lambda
func      a (first: Double, second: Double) -> Double {
	first + second
}

func generic<T>(first: T, second: T, operand: (T, T) -> T) -> T {
	operand(first, second)
}

func foo() {
	let result = generic(first: "A", second: "B", operand: +)
	let result2 = generic(first: 2, second: 4, operand: *)
}
