//
//  NSURL.swift
//  Kitch
//
//  Created by David Lee on 3/20/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation

extension NSURL {
	static func documentsURLByAppendingPathComponent(component: String) -> NSURL {
		let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		let documentsURL = paths.first!
		return documentsURL.URLByAppendingPathComponent(component)
	}
}