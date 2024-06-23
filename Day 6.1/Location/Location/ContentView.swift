//
//  ContentView.swift
//  Location
//
//  Created by Albert Gil on 9/6/24.
//

import SwiftUI
import CoreLocation

class LocationDataManager : NSObject, CLLocationManagerDelegate {
	 var locationManager = CLLocationManager()

	 override init() {
			super.init()
			locationManager.delegate = self
	 }
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
					switch manager.authorizationStatus {
					case .authorizedWhenInUse:  // Location services are available.
							// Insert code here of what should happen when Location services are authorized
							break
							
					case .restricted, .denied:  // Location services currently unavailable.
							// Insert code here of what should happen when Location services are NOT authorized
							break
							
					case .notDetermined:        // Authorization not determined yet.
							manager.requestWhenInUseAuthorization()
							break
							
					default:
							break
					}
			}
}

struct ContentView: View {
	init() {
		let manager = CLLocationManager()
		manager.requestWhenInUseAuthorization()
		manager.requestAlwaysAuthorization()
	}
	var body: some View {
		VStack(spacing: 16) {
//			Button("Continuar") {}
//			Button {
//				
//			} label: {
//				Image(systemName: "globe")
//			}
//			
//			Button {
//				
//			} label: {
//				Image(systemName: "globe")
//				Text("Continuar")
//			}
			
			Stepper(
				label: { Text("Name")},
				onIncrement: {},
				onDecrement: {},
				onEditingChanged: { _ in }
			)
			
			MyStepper(value: 1) {
				Text("My Stepper")
			} item: { value in
				HStack {
					Image(systemName: "globe")
					Text("\(value)")
				}
			}
			
			MyStepper(value: 1) {
				HStack {
					Image(systemName: "globe")
					Text("My Stepper")
				}
			} item: { value in
				Text("\(value)")
			}
			
			TweetView {
				Text("Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto. Lorem Ipsum ha sido el texto de relleno estándar de las industrias desde el año 1500, cuando un impresor (N. del T. persona que se dedica a la imprenta) desconocido usó una galería de textos y los mezcló de tal manera que logró hacer un libro de textos especimen.")
			}
			
			TweetView {
				HStack {
					Spacer()
					Image(systemName: "globe")
						.resizable()
						.scaledToFill()
					Spacer()
				}
				
			}
		}
		.padding()
	}
}

struct TweetView<Content: View>: View {
	let content: () -> Content
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text("Albert Gil Escura")
					.bold()
				Spacer()
				Group {
					Text("@agescura")
						
					Spacer()
					Text("35m")
				}
				.foregroundColor(.gray)
				Spacer()
				Button {
					
				} label: {
					Image(systemName: "globe")
				}
			}
			self.content()
				.frame(maxHeight: 200)
				.clipped()
			HStack(spacing: 16) {
				ForEach([ButtonAction.analytics, .retweet, .favorite], id: \.self) { action in
					Button {
						print(action)
					} label: {
						HStack {
							Image(systemName: "globe")
							Text(action.rawValue)
						}
//						.contextMenu(ContextMenu(menuItems: {
//							/*@START_MENU_TOKEN@*/Text("Menu Item 1")/*@END_MENU_TOKEN@*/
//							/*@START_MENU_TOKEN@*/Text("Menu Item 2")/*@END_MENU_TOKEN@*/
//							/*@START_MENU_TOKEN@*/Text("Menu Item 3")/*@END_MENU_TOKEN@*/
//						}))
					}
				}
			}
		}
	}
}

struct MyStepper<Label: View, Item: View>: View {
	@State var value: Int = 0
	let label: () -> Label
	let item: (Int) -> Item
	
	var body: some View {
		HStack {
			self.label()
			Spacer()
			self.item(self.value)
				.frame(width: 96, height: 42)
			VStack {
				Button("+") { self.value += 1 }
					.buttonStyle(BorderedProminentButtonStyle())
					.frame(width: 32, height: 32)
				Button("-") { self.value -= 1 }
					.buttonStyle(BorderedProminentButtonStyle())
					.frame(width: 32, height: 32)
			}
		}
	}
}

#Preview {
	ContentView()
}


enum ButtonAction: String, CaseIterable {
	case retweet, answer, like, analytics, favorite, share
}
