//
//  Factories.swift
//  Kitch
//
//  Created by David Lee on 3/20/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation

struct AudioFiles {
	static func make(fromURL url: NSURL) -> AudioFile {
		return LocalAudioFile(name: url.lastPathComponent!, url: url)
	}
}

struct Recorders {
	static func make() -> AudioRecordingMaker {
		return Recorder()
	}
}

struct Sessions {
	static func make() -> Session {
		return Session(name: "My Session", bin: AudioBin())
	}
}