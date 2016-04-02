//
//  AudioClip.swift
//  Kitch
//
//  Created by David Lee on 3/26/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation

/// A segment of an `AudioFile`.
protocol AudioClip: Named {
	var fileID: AudioFileID { get }

	var startPoint: NSTimeInterval { get }
	var endPoint: NSTimeInterval { get }
}