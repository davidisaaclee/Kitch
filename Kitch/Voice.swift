//
//  Voice.swift
//  Kitch
//
//  Created by David Lee on 3/26/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation

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