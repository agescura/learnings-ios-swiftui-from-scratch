import SwiftUI

struct Match: Identifiable {
	let id = UUID()
	let startDate: Date
	let local: String
	let visitor: String
	let result: String
}

/*
 (3412341341234123431241234, "Barcelona", "City", "0-0")
 */

extension Date {
	var dateTime: Date? {
		guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self)) else {
			 fatalError("Failed to strip time from Date object")
		}
		return date
	}
}

@Observable
class ContentModel {
	var originalMatchesResponse: [Match] = []
	var matches: [Date: [Match]] = [:]
	var selectedDay: Date?
	
	init() {}
	
	func fetch() {
		Task {
			try await Task.sleep(for: .seconds(0.5))
			self.originalMatchesResponse = [
				Match(startDate: Date().addingTimeInterval(-60*60*24*7), local: "Barcelona", visitor: "City", result: "0-0"),
				Match(startDate: Date().addingTimeInterval(-60*60*24*7), local: "Barcelona", visitor: "City", result: "0-0"),
				Match(startDate: Date().addingTimeInterval(-60*60*24*2), local: "Barcelona", visitor: "City", result: "0-0"),
				Match(startDate: Date().addingTimeInterval(-60*60*24*2), local: "Barcelona", visitor: "City", result: "0-0"),
				Match(startDate: Date().addingTimeInterval(-60*60*24), local: "Barcelona", visitor: "City", result: "0-0"),
				Match(startDate: Date(), local: "Barcelona", visitor: "City", result: "0-0"),
				Match(startDate: Date(), local: "Barcelona", visitor: "City", result: "0-0"),
				Match(startDate: Date().addingTimeInterval(60*60*24), local: "Barcelona", visitor: "City", result: "0-0"),
				Match(startDate: Date().addingTimeInterval(60*60*24*2), local: "Barcelona", visitor: "City", result: "0-0"),
				Match(startDate: Date().addingTimeInterval(60*60*24*2), local: "Barcelona", visitor: "City", result: "0-0")
			]
			
			self.matches = build(matches: self.originalMatchesResponse)
			if let day = self.matches.keys.first {
				self.selectedDay = day
			}
		}
	}
	
	func build(matches: [Match]) -> [Date: [Match]] {
		var candidate: [Date: [Match]] = [:]
		
		for match in matches {
			if let dateTime = match.startDate.dateTime {
				if candidate.keys.contains(dateTime) {
					if var matches = candidate[dateTime] {
						matches.append(match)
						candidate[dateTime] = matches
					}
					
				} else {
					candidate[dateTime] = [match]
				}
				
			}
			// 30-jul-2024 17:00
			// 30-jul-2024 19:00
			
			// crear clave 30-jul-2024 00:00
			// append las dos fechas
		}
		print(candidate)
		return candidate
	}
}

struct ContentView: View {
	let model: ContentModel
	
    var body: some View {
		 NavigationStack {
			 VStack(spacing: 0) {
				 ScrollView(.horizontal, showsIndicators: false) {
					 HStack {
						 ForEach(Array(self.model.matches.keys).sorted(by: { $0.compare($1) == .orderedAscending }), id: \.self) { day in
							 Button {
								 self.model.selectedDay	= day
							 } label: {
								 if Calendar.current.isDateInToday(day) {
									 Text("Today")
										 .foregroundStyle(day == self.model.selectedDay ? .pink : .black)
								 }
								 else if Calendar.current.isDateInYesterday(day) {
									 Text("Yesterday")
										 .foregroundStyle(day == self.model.selectedDay ? .pink : .black)
								 } else if Calendar.current.isDateInTomorrow(day) {
									 Text("Tomorrow")
										 .foregroundStyle(day == self.model.selectedDay ? .pink : .black)
								 } else {
									 Text(day, format: .dateTime.month().day())
										 .foregroundStyle(day == self.model.selectedDay ? .pink : .black)
								 }
							 }
						 }
						 Spacer()
					 }
					 .padding(4)
				 }
				 .background(Color.green)
				 ScrollView(showsIndicators: false) {
					 ForEach(
						self.model.matches[self.model.selectedDay ?? Date()] ?? []
					 ) { match in
						 VStack {
							 HStack {
								 Text(match.local)
								 Spacer()
								 Text(match.startDate, format: .dateTime)
								 Spacer()
								 Text(match.visitor)
							 }
						 }
					 }
				 }
				 Spacer()
			 }
			 .navigationBarTitleDisplayMode(.inline)
			 .toolbar {
				 ToolbarItem(placement: .topBarTrailing) {
					 Button {
						 
					 } label: {
						 Image(systemName: "magnifyingglass")
					 }
				 }
				 ToolbarItem(placement: .topBarLeading) {
					 Button {
						 
					 } label: {
						 Image(systemName: "line.3.horizontal")
					 }
				 }
				 ToolbarItem(placement: .principal) {
					 Text("Matches")
						 .font(.title)
						 .foregroundStyle(.pink)
				 }
			 }
		 }
		 .onAppear {
			 self.model.fetch()
		 }
    }
}

extension ContentModel {
	static var mock: ContentModel {
		ContentModel()
	}
}
#Preview {
	ContentView(model: .mock)
}
