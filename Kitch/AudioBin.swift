//
//  AudioBin.swift
//  Kitch
//
//  Created by David Lee on 3/26/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation

typealias AudioClipID = String
typealias AudioFileID = String

/// Holds all audio clips and files for use within a session.
struct AudioBin {
	var clips: [AudioClipID: AudioClip] = [:]
	var files: [AudioFileID: AudioFile] = [:]

	mutating func addClip(clip: AudioClip) -> AudioClipID {
		let id = NSUUID().UUIDString
		self.clips[id] = clip
		return id
	}

	mutating func addFile(file: AudioFile) -> AudioFileID {
		let id = NSUUID().UUIDString
		self.files[id] = file
		return id
	}
}