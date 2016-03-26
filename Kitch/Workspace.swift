//
//  Workspace.swift
//  Kitch
//
//  Created by David Lee on 3/26/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation

/// Holds working data which should be destroyed on application close.
final class Workspace {
	var sharedRecorder: AudioRecordingMaker = Recorders.make()

	/// All voices which are currently in use.
	var activeVoices: [Voice] = []

	/// Creates a sampler voice.
	func makeSampler(fromAudioFile audioFile: AudioFile) -> Sampler {
		let sampler = SimpleSampler(file: audioFile)
		sampler.voiceDelegate = self
		return sampler
	}

	func triggerPad(pad: Pad, session: Session) {
		guard let audioFileID = pad.audioFileID else { return }
		guard let audioFile = session.bin.files[audioFileID] else { return }
		let sampler = self.makeSampler(fromAudioFile: audioFile)
		sampler.play()
	}
}

extension Workspace: VoiceDelegate {
	func voiceDidBecomeBusy(voice: Voice) {
		self.activeVoices.append(voice)
	}

	func voiceDidBecomeFree(voice: Voice) {
		self.activeVoices
			.indexOf { $0 === voice }
			.tap { self.activeVoices.removeAtIndex($0) }
	}
}
