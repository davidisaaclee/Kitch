//
//  AudioBin.swift
//  Kitch
//
//  Created by David Lee on 3/26/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation

/// Holds all audio clips and files for use within a session.
struct AudioBin {
	var clips: [AudioClip] = []
	var files: [AudioFile] = []
}