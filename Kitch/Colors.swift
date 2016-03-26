//
//  Colors.swift
//  Kitch
//
//  Created by David Lee on 3/26/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
	private static let hexDict: [String: UInt] = [
		"cyanLight": 0x1abc9c,
		"cyanDark": 0x16a085,

		"greenLight": 0x2ecc71,
		"greenDark": 0x27ae60,

		"blueLight": 0x3498db,
		"blueDark": 0x2980b9,

		"purpleLight": 0x9b59b6,
		"purpleDark": 0x8e44ad,

		"blackLight": 0x34495e,
		"blackDark": 0x2c3e50,

		"yellowLight": 0xf1c40f,
		"yellowDark": 0xf39c12,

		"orangeLight": 0xe67e22,
		"orangeDark": 0xd35400,

		"redLight": 0xe74c3c,
		"redDark": 0xc0392b,

		"whiteLight": 0xecf0f1,
		"whiteDark": 0xbdc3c7,

		"greyLight": 0x95a5a6,
		"greyDark": 0x7f8c8d,
	]

	static func byName(name: String, alphaVal: CGFloat = 1) -> UIColor? {
		return self.hexDict[name].map { UIColor(rgb: $0, alphaVal: alphaVal) }
	}

	static var palette: [UIColor] {
		return self.hexDict.keys.map { self.byName($0) }.flatMap { $0 }
	}

	static func randomColor() -> UIColor? {
		return self.palette.pickRandomElement()
	}
}