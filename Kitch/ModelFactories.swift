//
//  ModelFactories.swift
//  Kitch
//
//  Created by David Lee on 3/20/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation

struct AudioFiles {
	static func make(fromURL url: NSURL) -> AudioFile {
		return LocalAudioFile(url: url)
	}
}

struct Samplers {
	static func make() -> Sampler {
		return SimpleSampler()
	}
}

struct Recorders {
	static func make(outputURL outputURL: NSURL) -> AudioRecordable {
		return Recorder()
	}
}