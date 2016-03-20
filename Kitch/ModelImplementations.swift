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

	var audioPlayer: AVAudioPlayer?

	init(file: AudioFile) {
		self.audioPlayer = try! AVAudioPlayer(data: file.data!)
	}

	func play() {
		guard let audioPlayer = self.audioPlayer else { return }
		audioPlayer.play()
	}

	func stop() {
		guard let audioPlayer = self.audioPlayer else { return }
		audioPlayer.stop()
	}
}

struct PolyphonicSamplerController {
	private var voices: [Sampler] = []

	mutating func makeSampler(fromFile audioFile: AudioFile) -> SimpleSampler {
		let sampler = SimpleSampler(file: audioFile)
		self.voices.append(sampler)
		return sampler
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
			AVNumberOfChannelsKey: 1,
			AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatLinearPCM)
		])
		self.avRecorder.prepareToRecord()
	}
}