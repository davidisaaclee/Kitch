//
//  ViewController.swift
//  Kitch
//
//  Created by David Lee on 3/20/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	var recorder: AudioRecordable!
	var samplerController: PolyphonicSamplerController!

	var mostRecentFile: AudioFile?

	override func viewDidLoad() {
		super.viewDidLoad()

		let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		let documentsURL = paths.first!

		self.recorder = Recorders.make(outputURL: documentsURL.URLByAppendingPathComponent("\(NSUUID().UUIDString).caf"))
		self.samplerController = PolyphonicSamplerController()
	}

	@IBAction func startRecording() {
		self.recorder.record()
	}

	@IBAction func stopRecording() {
		self.recorder.stop()
		self.mostRecentFile = self.recorder.export()
		self.recorder.reset()
	}

	private var voice: Sampler!

	@IBAction func startPlayback() {
		guard let file = self.mostRecentFile else { return }

		let voice = self.samplerController.makeSampler(fromFile: file)
		voice.play()
	}

	@IBAction func stopPlayback() {
//		voice.stop()
	}
}