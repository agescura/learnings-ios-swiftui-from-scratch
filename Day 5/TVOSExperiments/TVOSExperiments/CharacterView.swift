import SwiftUI

#if os(iOS)
struct CharacterView: View {
	let character: Character
	
	var body: some View {
		HStack(alignment: .center) {
			MyAsyncImage(
				url: character.imageUrl,
				content: { image in
					image
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: 64, height: 64)
				},
				placeholder: {
					Rectangle()
						.foregroundColor(.gray)
						.frame(width: 64, height: 64)
				}
			)
			
			VStack(alignment: .leading, spacing: 4) {
				Text(character.name)
					.font(.headline)
				
				Text(character.description)
					.font(.system(size: 16))
					.lineLimit(2)
				Spacer()
			}
		}
		.fixedSize(horizontal: false, vertical: true)
		.alignmentGuide(.listRowSeparatorLeading) { $0[.leading] }
	}
}
#endif

#if os(tvOS)
struct CharacterView: View {
	let character: Character
	@Environment(\.isFocused) var isFocused
	
	var body: some View {
		MyAsyncImage(
			url: character.imageUrl,
			content: { image in
				image
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: 200, height: 200)
			},
			placeholder: {
				Rectangle()
					.foregroundColor(.gray)
					.frame(width: 200, height: 200)
			}
		)
		.scaleEffect(isFocused ? 1.2 : 1)
		.animation(.easeInOut, value: isFocused)
	}
}
#endif

public struct MyAsyncImage<Content, Placeholder>: View
where
	Content: View,
	Placeholder: View
{
	private let url: URL?
	private let scale: CGFloat
	private let content: (Image) -> Content
	private let placeholder: () -> Placeholder
	
	public init(
		url: URL?,
		scale: CGFloat = 1.0,
		@ViewBuilder content: @escaping (Image) -> Content,
		@ViewBuilder placeholder: @escaping () -> Placeholder
	){
		self.url = url
		self.scale = scale
		self.content = content
		self.placeholder = placeholder
	}
	
	public var body: some View {
		AsyncImage(
			url: url ?? Bundle.main.url(forResource: "placeholder", withExtension: "png"),
			scale: self.scale,
			content: self.content,
			placeholder: self.placeholder
		)
	}
}
