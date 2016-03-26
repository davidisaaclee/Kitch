//
//  Session.swift
//  Kitch
//
//  Created by David Lee on 3/26/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation
import UIKit

/// A document produced by Kitch - think of this as a song.
struct Session: Named {
	var name: String
	var bin: AudioBin = AudioBin()
	var pads: [Coordinates: Pad]
}




struct Coordinates {
	let x: Int
	let y: Int
}

extension Coordinates: Hashable {
	var hashValue: Int {
		return -1
	}
}

func == (left: Coordinates, right: Coordinates) -> Bool {
	return (left.x == right.x) && (left.y == right.y)
}

protocol Pad {
	var color: UIColor { get }
	var audioFile: AudioFile? { get set }
}

struct SimplePad: Pad {
	var color: UIColor
	var audioFile: AudioFile?
}