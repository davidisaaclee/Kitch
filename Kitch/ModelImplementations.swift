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
	var name: String
	let url: NSURL

	var data: NSData? {
		return NSData(contentsOfURL: self.url)
	}

	func dataForSegment(start start: NSTimeInterval, end: NSTimeInterval) -> NSData? {
		// TODO
		return NSData()
	}
}

final class SimpleSampler: Sampler {
	weak var voiceDelegate: VoiceDelegate?
	var busy: Bool = false
	var audioPlayer: AVAudioPlayer?

	/// Helper object to bridge to Objective-C protocol `AVAudioPlayerDelegate`.
	private var audioPlayerDelegate: AudioPlayerDelegate!

	init(file: AudioFile) {
		self.audioPlayer = try! AVAudioPlayer(data: file.data!)
		self.audioPlayerDelegate = AudioPlayerDelegate(sampler: self)

		self.audioPlayer?.delegate = self.audioPlayerDelegate
	}

	func play() {
		guard let audioPlayer = self.audioPlayer else { return }
		audioPlayer.play()
		self.voiceDelegate?.voiceDidBecomeBusy(self)
	}

	func stop() {
		guard let audioPlayer = self.audioPlayer else { return }
		audioPlayer.stop()
	}

	private class AudioPlayerDelegate: NSObject, AVAudioPlayerDelegate {
		unowned let sampler: SimpleSampler

		init(sampler: SimpleSampler) {
			self.sampler = sampler
		}

		@objc func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
			self.sampler.voiceDelegate?.voiceDidBecomeFree(self.sampler)
		}
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

struct Recorder: AudioRecordingMaker {
	var avRecorder: AVAudioRecorder!

	init() {
		let outputURL = NSURL.documentsURLByAppendingPathComponent("\(NSUUID().UUIDString).caf")
		self.avRecorder = try! AVAudioRecorder(URL: outputURL, settings: [
			AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
			AVSampleRateKey: 44100,
			AVNumberOfChannelsKey: 1,
			AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatLinearPCM)
		])
		self.avRecorder.prepareToRecord()
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
}