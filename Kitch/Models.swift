//
//  Models.swift
//  Kitch
//
//  Created by David Lee on 3/20/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation

// MARK: - Audio engine models

protocol AudioFile {
	var data: NSData? { get }
	func dataForSegment(start start: NSTimeInterval, end: NSTimeInterval) -> NSData?
}

protocol Voice {
	var busy: Bool { get }
}

protocol PlaybackControllable {
	func play()
	func stop()
}

protocol Sampler: Voice, PlaybackControllable {
//	init(file: AudioFile)
}



// MARK: - User-facing models

protocol AudioRecordable {
	func record()
	func stop()
	func export() -> AudioFile
	mutating func reset()
}

protocol AudioClip {
	var file: AudioFile { get }

	var startPoint: NSTimeInterval { get }
	var endPoint: NSTimeInterval { get }
}

protocol Session {
	typealias ClipIndex

	func clipAtIndex(index: ClipIndex) -> AudioClip?
}