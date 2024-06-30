import Foundation
import SwiftUI

struct Message {
}

@Observable
class ChatDetailModel {
	var messages: [Message] = []
}

struct ChatDetailView	{
	var body: some View {
		Text("Detail")
	}
}
