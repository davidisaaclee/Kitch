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

	override func viewDidLoad() {
		super.viewDidLoad()

		let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		let documentsURL = paths.first!

		self.recorder = Recorders.make(outputURL: documentsURL.URLByAppendingPathComponent("\(NSUUID().UUIDString).caf"))
	}

	@IBAction func record() {
		self.recorder.record()
	}

	@IBAction func stop() {
		self.recorder.stop()
		let file = self.recorder.export()
		print(file)
		self.recorder.reset()
	}
}