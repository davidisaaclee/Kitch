//
//  ModelImplementations.swift
//  Kitch
//
//  Created by David Lee on 3/20/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation
import AVFoundation

struct LocalAudioFile: AudioFile {
	let url: NSURL

	var data: NSData? {
		return NSData(contentsOfURL: self.url)
	}

	func dataForSegment(start start: NSTimeInterval, end: NSTimeInterval) -> NSData? {
		// TODO
		return NSData()
	}
}

struct SimpleSampler: Sampler {
	var busy: Bool = false

	func load(file: AudioFile) {
		// TODO
	}

	func play() {
		// TODO
	}

	func stop() {
		// TODO
	}
}

struct PolyphonicSamplerController: Polyphonic {
	private let voices: [Voice]

	init(numberOfVoices: Int) {
		self.voices = Array(count: numberOfVoices, repeatedValue: Samplers.make())
	}

	func dequeueVoice() -> Voice? {
		return self.voices
			.filter { $0.busy == false }
			.first
	}
}

struct Recorder: AudioRecordable {
	var avRecorder: AVAudioRecorder!

	init() {
		self.reset()
	}

	func record() {
		self.avRecorder.record()
	}

	func stop() {
		self.avRecorder.pause()
	}

	func export() -> AudioFile {
		self.avRecorder.stop()
		return AudioFiles.make(fromURL: self.avRecorder.url)
	}

	mutating func reset() {
		let outputURL = NSURL.documentsURLByAppendingPathComponent("\(NSUUID().UUIDString).caf")
		self.avRecorder = try! AVAudioRecorder(URL: outputURL, settings: [
			AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
			AVSampleRateKey: 44100,
			AVNumberOfChannelsKey: 1
		])
		self.avRecorder.prepareToRecord()
	}
}