import SwiftUI

struct ChatListRowView: View {
	var body: some View {
		HStack(alignment: .top) {
			Image("portrait")
				.imageStyle(.circle)
			VStack(alignment: .leading, spacing: 0) {
				HStack(alignment: .firstTextBaseline) {
					Text("Micho Diana")
						.textStyle(.title)
					Spacer()
					Text("18:38")
						.textStyle(.time)
				}
				
				HStack(alignment: .firstTextBaseline) {
					Image(systemName: "checkmark.rectangle")
						.imageStyle(.icon)
					Text("voy")
						.textStyle(.body)
					Spacer()
					Image(systemName: "clock")
						.imageStyle(.icon)
				}
				.foregroundStyle(.gray)
			}
		}
	}
}

enum Shape {
	case `default`
	case circle
}

protocol ImageStyle {
	var frame: CGSize { get }
	var shape: Shape { get }
}

struct CircleImageStyle: ImageStyle {
	let frame: CGSize = CGSize(width: 50, height: 50)
	let shape: Shape = .circle
}

struct IconImageStyle: ImageStyle {
	let frame: CGSize = CGSize(width: 10, height: 10)
	let shape: Shape = .default
}

extension ImageStyle where Self == CircleImageStyle {
	static var circle: ImageStyle { CircleImageStyle() }
}

extension ImageStyle where Self == IconImageStyle {
	static var icon: ImageStyle { IconImageStyle() }
}

extension Image {
	@ViewBuilder
	func imageStyle(_ style: ImageStyle) -> some View {
		switch style.shape {
			case .default:
				self
					.resizable()
					.frame(width: style.frame.width, height: style.frame.height)
					.scaledToFit()
			case .circle:
				self
					.resizable()
					.frame(width: style.frame.width, height: style.frame.height)
					.scaledToFit()
					.clipShape(Circle())
		}
	}
}


protocol TextStyle {
	var font: String { get }
	var size: CGFloat { get }
	var color: Color { get }
}

//enum TextStyle {
//	case title, body
//}

struct TitleTextStyle: TextStyle {
	let font: String = LatoFonts.bold.rawValue
	let size: CGFloat = 18
	let color: Color = .customBlack
}

struct BodyTextStyle: TextStyle {
	let font: String = LatoFonts.regular.rawValue
	let size: CGFloat = 16
	let color: Color = .customGray
}

struct TimeTextStyle: TextStyle {
	let font: String = LatoFonts.regular.rawValue
	let size: CGFloat = 14
	let color: Color = .customGray
}

extension TextStyle where Self == TitleTextStyle {
	static var title: TextStyle { TitleTextStyle() }
}

extension TextStyle where Self == BodyTextStyle {
	static var body: TextStyle { BodyTextStyle() }
}

extension TextStyle where Self == TimeTextStyle {
	static var time: TextStyle { TimeTextStyle() }
}

//extension TextStyle {
//	var font: String {
//		switch self {
//			case .title:
//				return LatoFonts.bold.rawValue
//			case .body:
//				return LatoFonts.regular.rawValue
//		}
//	}
//	var size: CGFloat {
//		switch self {
//			case .title:
//				return 18
//			case .body:
//				return 14
//		}
//	}
//	var color: Color {
//		switch self {
//			case .title:
//				return .black
//			case .body:
//				return .gray
//		}
//	}
//}

extension Text {
	func textStyle(_ style: TextStyle) -> Text {
		self
			.font(.custom(style.font, size: style.size))
			.foregroundStyle(style.color)
	}
}

#Preview {
	VStack {
		ChatListRowView()
			.padding()
		Card()
		Spacer()
	}
	.background(Color.gray)
}

struct Card: View {
	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			HStack {
				Image(systemName: "globe")
					.imageStyle(.icon)
				Text("Entrega")
					.textStyle(.title)
				Spacer()
				Button("EN DESTINO") {
					
				}
				.buttonStyle(.borderedProminent)
			}
			Text("17:00 18:00 C-123123123123132")
				.textStyle(.title)
			Text("Tamas Bunce")
				.textStyle(.body)
			Text("Calle Doctor Jose2 asdad  asd asd as ad asd as das das da sd asd as...")
				.textStyle(.body)
				.lineLimit(1)
		}
		.padding()
		.background(Color.customWhite)
		.padding()
		.clipShape(RoundedRectangle(cornerRadius: 8))
	}
}
