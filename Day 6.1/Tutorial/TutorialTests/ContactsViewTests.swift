import XCTest
@testable import Tutorial
import SnapshotTesting

final class ContactsViewTests: XCTestCase {

	func testInit_addUserButtonTapped_addContactModel() {
		let model = ContactsModel()
		
		model.addUserButtonTapped()
		
		XCTAssertEqual(
			model.addContactModel,
			AddContactModel(user: .new)
		)
	}
	
	func testWHenCancelButtonTappedAddContactNil() {
		let model = ContactsModel(
			addContactModel: AddContactModel(user: .new)
		)
		
		model.cancelButtonTapped()
		
		XCTAssertEqual(
			model.addContactModel,
			nil
		)
	}
	
	func testHappyPath() {
		let model = ContactsModel()
		var user = User.new
		
		model.addUserButtonTapped()
		
		assertSnapshots(
			of: ContactsView(model: model),
			as: [.image]
		)
		
		XCTAssertEqual(
			model.addContactModel,
			AddContactModel(user: user)
		)
		
		model.addContactModel?.user.name = "Albert"
		user.name = "Albert"
		
		XCTAssertEqual(
			model.addContactModel,
			AddContactModel(user: user)
		)
		
		model.addContactModel?.user.username = "agescura"
		user.username = "agescura"
		
		XCTAssertEqual(
			model.addContactModel,
			AddContactModel(user: user)
		)
		
//		model.addContactModel?.user.country = "Spain"
//		user.country = "Spain"
//		
		XCTAssertEqual(
			model.addContactModel,
			AddContactModel(user: user)
		)
		
		model.confirmAddUserButtonTapped()
		
		XCTAssertEqual(
			model.addContactModel,
			nil
		)
		XCTAssertEqual(
			model.users,
			[user]
		)
		
		assertSnapshots(
			of: ContactsView(model: model),
			as: [.image]
		)
	}
}
