//
//  LocalAudioFile.swift
//  Kitch
//
//  Created by David Lee on 3/26/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation

/// Represents an audio file on local storage.
struct LocalAudioFile: AudioFile {
	var id: AudioFileID

	var name: String

	/// URL of the backing audio file.
	let url: NSURL

	var data: NSData? {
		return NSData(contentsOfURL: self.url)
	}
	

//	func dataForSegment(start start: NSTimeInterval, end: NSTimeInterval) -> NSData? {
//		// TODO
//		return NSData()
//	}
}