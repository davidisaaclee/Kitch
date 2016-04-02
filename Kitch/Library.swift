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

final class RealmLibrary: Library {
	var realm: Realm

	init(realm: Realm) {
		self.realm = realm
	}

	func saveSession(session: Session) {
		self.writeObject(RealmSession(session))
	}

	func loadSession(name: String) -> Session? {
		return nil
	}

	private func writeObject(object: Object) {
		try! self.realm.write {
			self.realm.add(object)
		}
	}
}


protocol Encodable {
	associatedtype EncodedType

	init(_ encoded: EncodedType)
	func encode() -> EncodedType
}

class RealmSession: Object {
	dynamic var name: String = ""
	dynamic var bin: RealmAudioBin!
	let pads: List<RealmPadSlot> = List<RealmPadSlot>()

	convenience required init(_ session: Session) {
		self.init()
		self.name = session.name
		self.bin = RealmAudioBin(session.bin)
		self.pads.appendContentsOf(session.pads.map(RealmPadSlot.init))
	}
}

extension Session: Encodable {
	init(_ encoded: RealmSession) {
		self.init(name: encoded.name, bin: AudioBin(encoded.bin), pads: [:])
	}

	func encode() -> RealmSession {
		return RealmSession(self)
	}
}


class RealmPadSlot: Object {
	dynamic var coordinates: RealmCoordinates!
	dynamic var pad: RealmPad!

	convenience init(coordinates: Coordinates, pad: Pad) {
		self.init()

		self.coordinates = coordinates.encode()
		self.pad = RealmPad(pad)
	}
}

class RealmPad: Object {
	dynamic var colorData: NSData!
	dynamic var audioFileID: String?

	convenience init(_ pad: Pad) {
		self.init()
		self.colorData = NSKeyedArchiver.archivedDataWithRootObject(pad.color)
		self.audioFileID = pad.audioFileID
	}
}

extension SimplePad: Encodable {
	init(_ encoded: RealmPad) {
		self.init(color: NSKeyedUnarchiver.unarchiveObjectWithData(encoded.colorData) as! UIColor, audioFileID: encoded.audioFileID)
	}

	func encode() -> RealmPad {
		return RealmPad(self)
	}
}


class RealmAudioBin: Object {
	let clips: List<RealmAudioClip> = List<RealmAudioClip>()
	let files: List<RealmAudioFile> = List<RealmAudioFile>()

	convenience init(_ bin: AudioBin) {
		self.init()
		self.clips.appendContentsOf(bin.clips.map(RealmAudioClip.init))
		self.files.appendContentsOf(bin.files.map(RealmAudioFile.init))
	}
}

extension AudioBin: Encodable {
	init(_ encoded: RealmAudioBin) {
		let files: [AudioFileID: AudioFile] = encoded.files
			.map(LocalAudioFile.init)
			.map { [$0.id: $0] }
			.reduce([:], combine: Dictionary.merge)

		self.init(clips: [:], files: files)
	}

	func encode() -> RealmAudioBin {
		return RealmAudioBin(self)
	}
}



class RealmAudioClip: Object {
	dynamic var id: String = ""
	dynamic var name: String = ""
	dynamic var fileID: String = ""
	dynamic var startPoint: Double = 0.0
	dynamic var endPoint: Double = 0.0

	convenience init(id: AudioClipID, clip: AudioClip) {
		self.init()

		self.id = id
		self.name = clip.name
		self.fileID = clip.fileID
		self.startPoint = clip.startPoint
		self.endPoint = clip.endPoint
	}
}



class RealmAudioFile: Object {
	dynamic var id: String = ""
	dynamic var name: String = ""
	dynamic var urlString: String = ""

	convenience init(id: AudioFileID, file: AudioFile) {
		self.init()
		self.id = id
		self.name = file.name
		self.urlString = file.url.absoluteString
	}
}

extension LocalAudioFile: Encodable {
	init(_ encoded: RealmAudioFile) {
		self.init(id: encoded.id, name: encoded.name, url: NSURL(fileURLWithPath: encoded.urlString))
	}

	func encode() -> RealmAudioFile {
		return RealmAudioFile(id: self.id, file: self)
	}
}



class RealmCoordinates: Object {
	dynamic var row: Int = -1
	dynamic var column: Int = -1

	convenience init(_ coordinates: Coordinates) {
		self.init()
		self.row = coordinates.row
		self.column = coordinates.column
	}
}

extension Coordinates: Encodable {
	init(_ encoded: RealmCoordinates) {
		self.init(column: encoded.column, row: encoded.row)
	}

	func encode() -> RealmCoordinates {
		return RealmCoordinates(self)
	}
}