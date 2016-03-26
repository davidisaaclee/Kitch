//
//  Models.swift
//  Kitch
//
//  Created by David Lee on 3/20/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation

// MARK: - Utility protocols

protocol Named {
	var name: String { get set }
}

// MARK: - Audio engine models

/// Directly maps to an audio file on disk - an uncut, unmodifed buffer of audio.
protocol AudioFile: Named {
	var data: NSData? { get }
	func dataForSegment(start start: NSTimeInterval, end: NSTimeInterval) -> NSData?
}

protocol VoiceDelegate: class {
	func voiceDidBecomeBusy(voice: Voice)
	func voiceDidBecomeFree(voice: Voice)
}

/// A synthesis voice, which can be `busy` (making sound or potentially making sound), or free to be recycled.
protocol Voice: class {
	weak var voiceDelegate: VoiceDelegate? { get set }

	/// Returns true iff this voice can't be recycled.
	var busy: Bool { get }
}

protocol PlaybackControllable {
	func play()
	func stop()
}

protocol Sampler: Voice, PlaybackControllable {
	init(file: AudioFile)
}



// MARK: - User-facing models

protocol AudioRecordingMaker {
	func record()
	func stop()
	func export() -> AudioFile
}

/// A segment of an `AudioFile`.
protocol AudioClip: Named {
	var file: AudioFile { get }

	var startPoint: NSTimeInterval { get }
	var endPoint: NSTimeInterval { get }
}

/// Holds all audio clips and files for use within a session.
struct AudioBin {
	var clips: [AudioClip] = []
	var files: [AudioFile] = []
}

/// A document produced by Kitch - think of this as a song.
struct Session: Named {
	var name: String
	var bin: AudioBin = AudioBin()
}

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

	// - Private

	private var samplerController: PolyphonicSamplerController = PolyphonicSamplerController()
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
