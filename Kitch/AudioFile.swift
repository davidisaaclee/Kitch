//
//  AudioFile.swift
//  Kitch
//
//  Created by David Lee on 3/26/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation

/// Directly maps to an audio file on disk - an uncut, unmodifed buffer of audio.
protocol AudioFile: Named {
	var data: NSData? { get }
	func dataForSegment(start start: NSTimeInterval, end: NSTimeInterval) -> NSData?
}