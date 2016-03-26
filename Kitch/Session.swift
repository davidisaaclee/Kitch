//
//  Session.swift
//  Kitch
//
//  Created by David Lee on 3/26/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation

/// A document produced by Kitch - think of this as a song.
struct Session: Named {
	var name: String
	var bin: AudioBin = AudioBin()
}