//
//  SimpleSampler.swift
//  Kitch
//
//  Created by David Lee on 3/26/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation
import AVFoundation

/// Simple implementation of a `AudioFile`-backed sampler.
final class SimpleSampler: Sampler {
	weak var voiceDelegate: VoiceDelegate?
	var busy: Bool = false

	/// The underlying AVFoundation audio player.
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
