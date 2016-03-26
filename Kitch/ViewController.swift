//
//  ViewController.swift
//  Kitch
//
//  Created by David Lee on 3/20/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	var workspace: Workspace = Workspace()
	var session: Session = Sessions.make()

	@IBAction func startRecording() {
		self.workspace.sharedRecorder.record()
	}

	@IBAction func stopRecording() {
		self.workspace.sharedRecorder.pause()
		self.session.bin.files.append(self.workspace.sharedRecorder.export())
		self.workspace.sharedRecorder = Recorders.make()
	}

	@IBAction func startPlayback() {
		guard let file = self.session.bin.files.last else { return }

		let voice = self.workspace.makeSampler(fromAudioFile: file)
		voice.play()
	}

	@IBAction func stopPlayback() {
//		voice.stop()
	}
}