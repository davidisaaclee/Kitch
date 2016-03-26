//
//  PadCells.swift
//  Kitch
//
//  Created by David Lee on 3/26/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation
import UIKit

protocol PadCellDelegate: class {
	func pad(pad: PadCell, wasTappedWithTouch touch: UITouch)
	func pad(pad: PadCell, beganPressWithTouch touch: UITouch)
	func pad(pad: PadCell, endedPressWithTouch touch: UITouch)
}

class PadCell: UICollectionViewCell {
	weak var delegate: PadCellDelegate?

	enum Configuration {
		case Empty
		case CanPlay
		case Editing
	}

	var configuration: Configuration = .Empty {
		didSet {
			self.layer.borderColor = nil
			self.layer.borderWidth = 0
			self.layer.cornerRadius = 0

			switch self.configuration {
			case .Empty:
				self.backgroundColor = Colors.byName("blackLight")!
				self.layer.borderColor = Colors.byName("blackDark")!.CGColor
				self.layer.borderWidth = 1

			case .CanPlay:
				break

			case .Editing:
				self.layer.cornerRadius = 10
			}
		}
	}

	private let maximumTapTime: NSTimeInterval = 0.2
	private var currentTouch: (touch: UITouch, time: NSDate)?

	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		guard self.currentTouch == nil else { return }
		guard let firstTouch = touches.first else { fatalError() }

		self.currentTouch = (touch: firstTouch, time: NSDate())
		self.delegate?.pad(self, beganPressWithTouch: firstTouch)
	}

	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		guard let currentTouch = self.currentTouch else { return }
		if touches.contains(currentTouch.touch) {
			if NSDate().timeIntervalSinceDate(currentTouch.time) < self.maximumTapTime {
				self.delegate?.pad(self, wasTappedWithTouch: currentTouch.touch)
			}
			self.delegate?.pad(self, endedPressWithTouch: currentTouch.touch)
			self.currentTouch = nil
		}
	}
}