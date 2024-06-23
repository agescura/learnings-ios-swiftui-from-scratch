import SwiftUI

struct ChatListRowView: View {
	
	var body: some View {
		HStack(alignment: .top) {
			Image("portrait")
				.resizable()
				.frame(width: 50, height: 50)
				.scaledToFill()
				.clipShape(Circle())
			VStack(alignment: .leading, spacing: 0) {
				HStack(alignment: .firstTextBaseline) {
					Text("Micho Diana")
						.bold()
					Spacer()
					Text("18:38")
						.font(.caption)
						.foregroundStyle(.gray)
				}
				
				HStack(alignment: .firstTextBaseline) {
					Image(systemName: "checkmark.rectangle")
						.resizable()
						.frame(width: 10, height: 10)
						.scaledToFit()
					Text("voy")
					Spacer()
					Image(systemName: "clock")
				}
				.foregroundStyle(.gray)
			}
		}
	}
}

#Preview {
	VStack {
		ChatListRowView()
			.padding()
		Spacer()
	}
}
