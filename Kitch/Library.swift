//
//  Library.swift
//  Kitch
//
//  Created by David Lee on 3/26/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation
import RealmSwift

protocol Library {
	func saveSession(session: Session)
	func loadSession(name: String) -> Session?
}

//final class RealmLibrary: Library {
//	init(realm: Realm) {
//
//	}
//
//	func saveSession(session: Session) {
//
//	}
//
//	func loadSession(name: String) -> Session? {
//		return nil
//	}
//}
//
//class RealmSession: Object {
//	dynamic var name: String = ""
//	dynamic var pads: List<RealmPadSlot>
//
//	init(session: Session) {
//		self.name = session.name
//	}
//}
//
//class RealmPadSlot: Object {
//
//}
//
//class RealmPad: Object {
//
//}