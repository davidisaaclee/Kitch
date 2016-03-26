//
//  Array+pickRandomElement.swift
//  Kitch
//
//  Created by David Lee on 3/26/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation

extension Array {
	func pickRandomElement() -> Generator.Element? {
		let unsignedCount = UInt32(self.count)
		let index = Int(arc4random_uniform(unsignedCount))
		return self.indices.contains(index) ? self[index] : nil
	}
}