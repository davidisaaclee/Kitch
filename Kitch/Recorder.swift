//
//  Recorder.swift
//  Kitch
//
//  Created by David Lee on 3/26/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation
import AVFoundation

/// Records audio to a local file.
struct Recorder: AudioRecordingMaker {
	/// The backing AVFoundation audio recorder.
	var avRecorder: AVAudioRecorder!

	init(fileName: String = NSUUID().UUIDString) {
		let outputURL = NSURL.documentsURLByAppendingPathComponent("\(fileName).caf")
		self.avRecorder = try! AVAudioRecorder(URL: outputURL, settings: [
			AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
			AVSampleRateKey: 44100,
			AVNumberOfChannelsKey: 1,
			AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatLinearPCM)
			])
		self.avRecorder.prepareToRecord()
	}

	/// Starts recording, or resumes if previously paused.
	func record() {
		self.avRecorder.record()
	}

	/// Pauses recording. (Resume recording by calling `Recorder.record()`.)
	func pause() {
		self.avRecorder.pause()
	}

	/// Stops recording and exports the audio as an `AudioFile`.
	func export() -> AudioFile {
		self.avRecorder.stop()
		return AudioFiles.make(fromURL: self.avRecorder.url)
	}
}