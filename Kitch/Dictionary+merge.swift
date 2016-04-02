//
//  Dictionary+merge.swift
//  Kitch
//
//  Created by David Lee on 3/26/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation

extension Dictionary {
	/// Non-mutating merge of two dictionaries. The provided dictionary takes precedence in any key collisions.
	static func merge(lhs: Dictionary, rhs: Dictionary) -> Dictionary {
		return lhs.mergedWith(rhs)
	}

	/// Mutating merge of two dictionaries. The provided dictionary takes precedence in any key collisions.
	mutating func mergeWith(otherDictionary: Dictionary) {
		for (key, value) in otherDictionary {
			self[key] = value
		}
	}

	/// Non-mutating merge of two dictionaries. The provided dictionary takes precedence in any key collisions.
	func mergedWith(otherDictionary: Dictionary) -> Dictionary {
		var copy = self
		copy.mergeWith(otherDictionary)
		return copy
	}
}