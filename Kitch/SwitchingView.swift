//
//  SwitchingView.swift
//  Kitch
//
//  Created by David Lee on 3/26/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import Foundation
import UIKit

/// A view which shows one view from a set of views.
final class SwitchingView: UIView {
	typealias ViewIdentifier = String

	private var views: [ViewIdentifier: UIView] = [:]

	var activeViewIdentifier: ViewIdentifier? {
		didSet {
			oldValue.flatMap(self.viewForIdentifier)?.hidden = true
			self.activeViewIdentifier.flatMap(self.viewForIdentifier)?.hidden = false
		}
	}

	func registerView(view: UIView, forIdentifier id: ViewIdentifier) {
		self.views[id]?.removeFromSuperview()

		view.hidden = true
		self.views[id] = view
		self.addSubview(view)

		self.activeViewIdentifier.flatMap(self.viewForIdentifier)?.hidden = false
	}

	func viewForIdentifier(id: ViewIdentifier) -> UIView? {
		return self.views[id]
	}
}