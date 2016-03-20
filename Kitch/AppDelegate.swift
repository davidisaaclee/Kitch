//
//  AppDelegate.swift
//  Kitch
//
//  Created by David Lee on 3/20/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		self.setupAudioSession()
		return true
	}


	func setupAudioSession() {
		let session = AVAudioSession.sharedInstance()
		session.requestRecordPermission { permitted in
			print(permitted ? "thanks" : "oh")
		}
		try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: .DefaultToSpeaker)
		try! session.setActive(true)
	}
}

