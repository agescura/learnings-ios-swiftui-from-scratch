import SwiftUI
import Dependencies

@Observable
class HomeModel {
	var characters: [Character] = []

	@ObservationIgnored
	@Dependency(\.apiClient) var apiClient
	
	func task() async {
		do {
			self.characters = try await self.apiClient.characters()
		} catch {
			print(error)
		}
	}
	
	func nextPage() {
		print("starting nextPage")
		Task {
			do {
				try await self.characters.append(contentsOf: self.apiClient.characters())
			} catch {
				print(error)
			}
		}
	}
}

#if os(iOS)
struct HomeView: View {
	let model: HomeModel
	@State var name: String = ""
	@State var password: String = ""
	
	@FocusState var focusedField: Int?
	
	init(
		model: HomeModel
	) {
		self.model = model
	}
	
	var body: some View {
		NavigationStack {
			List {
				TextField("Name", text: self.$name)
					.focused($focusedField, equals: 0)
					.onSubmit {
						self.focusedField = 1
					}
				TextField("password", text: self.$password)
					.focused($focusedField, equals: 1)
				Button("Continuar") {
				}
//				ForEach(self.model.characters) { character in
//					Button {
//						//					self.model.characterButtonTapped(character: character)
//					} label: {
//						CharacterView(character: character)
//					}
//					.buttonStyle(.plain)
//				}
			}
			.defaultFocus($focusedField, 0)
			.navigationTitle("Home")
			.toolbar {
				ToolbarItem(placement: .confirmationAction) {
					Button {
						self.model.nextPage()
					} label: {
						Image(systemName: "square.and.arrow.down.fill")
					}
				}
			}
		}
		.task { await self.model.task() }
		.onAppear {
			self.focusedField = 0
		}
	}
}
#endif

#if os(tvOS)
struct HomeView: View {
	let model: HomeModel
	
	var body: some View {
		ScrollView {
			LazyVStack(alignment: .leading) {
				HStack {
					Button {
						print("Lo ultimo")
					} label: {
						Text("Lo ultimo")
					}
					Spacer()
				}
				.focusSection()
				
				ScrollView(.horizontal) {
					LazyHGrid(
						rows: [GridItem(.adaptive(minimum: 200))]
					) {
						ForEach(self.model.characters) { character in
							ZStack {
								CharacterView(character: character)
							}
							.focusable()
						}
					}
				}
				Text("Seguir viendo")
				ScrollView(.horizontal) {
					LazyHGrid(
						rows: [GridItem(.adaptive(minimum: 200))]
					) {
						ForEach(self.model.characters) { character in
							ZStack {
								CharacterView(character: character)
							}
							.focusable()
						}
					}
				}
				Text("Peliculas")
				ScrollView(.horizontal) {
					LazyHGrid(
						rows: [GridItem(.adaptive(minimum: 200))]
					) {
						ForEach(self.model.characters) { character in
							ZStack {
								CharacterView(character: character)
							}
							.focusable()
						}
					}
				}
			}
		}
		.task { await self.model.task() }
	}
}
#endif

#Preview {
	HomeView(model: HomeModel())
}
