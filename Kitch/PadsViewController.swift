//
//  PadsViewController.swift
//  Kitch
//
//  Created by David Lee on 3/26/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import UIKit

class PadsViewController: UIViewController {

	private enum Mode {
		case Normal
		case Shift
	}
	private var mode: Mode = .Normal {
		didSet {
			print("Set mode: \(self.mode)")
			self.padsView.reloadData()
		}
	}

	var workspace: Workspace = Workspace()
	var session: Session = Sessions.make()

	private struct Constants {
		static let rows = 5
		static let columns = 3
	}

	@IBOutlet var padsView: UICollectionView! {
		didSet {
			self.padsView.dataSource = self
			self.padsView.registerClass(PadPlayCell.self, forCellWithReuseIdentifier: Strings.Interface.PadPlayCellReuseIdentifier)
			self.padsView.registerClass(PadRecordCell.self, forCellWithReuseIdentifier	: Strings.Interface.PadRecordCellReuseIdentifier)
			self.padsView.registerClass(PadEmptyCell.self, forCellWithReuseIdentifier	: Strings.Interface.PadEmptyCellReuseIdentifier)
		}
	}

	@IBOutlet var shiftButton: UIView! {
		didSet {
			self.shiftButton.addGestureRecognizer(self.pressShiftGestureRecognizer)
		}
	}

	let pressShiftGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer()

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}

	private func setup() {
		self.pressShiftGestureRecognizer.minimumPressDuration = 0
		self.pressShiftGestureRecognizer.addTarget(self, action: #selector(self.pressShift(_:)))
	}

	override func viewDidLoad() {
		guard let flowLayout = self.padsView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

		flowLayout.itemSize = CGSize(width: self.view.bounds.width / 3, height: self.view.bounds.height / 5)
		flowLayout.minimumLineSpacing = 0
		flowLayout.minimumInteritemSpacing = 0
	}

	func tapOnPadAtCoordinates(coordinates: Coordinates) {
		if self.mode == .Normal {
			self.session.pads[coordinates].tap(self.workspace.triggerPad)
		}
	}

	@objc private func pressShift(recognizer: UILongPressGestureRecognizer) {
		switch recognizer.state {
		case .Began:
//			self.mode = .Shift
			break

		case .Ended:
//			self.mode = .Normal

			switch self.mode {
			case .Normal:
				self.mode = .Shift

			case .Shift:
				self.mode = .Normal
			}

		default: return
		}
	}

	private func coordinatesForIndex(index: Int, wrapAt: Int) -> Coordinates {
		return Coordinates(x: index % wrapAt, y: index / wrapAt)
	}
}


extension PadsViewController: UICollectionViewDataSource {
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return Constants.columns * Constants.rows
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		guard let pad = self.session.pads[self.coordinatesForIndex(indexPath.item, wrapAt: Constants.columns)] else {
			let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Strings.Interface.PadEmptyCellReuseIdentifier, forIndexPath: indexPath)
			guard let emptyCell = cell as? PadEmptyCell else { return cell }

			emptyCell.delegate = self
			emptyCell.backgroundColor = UIColor.darkGrayColor()
			return emptyCell
		}

		switch self.mode {
		case .Normal:
			let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Strings.Interface.PadPlayCellReuseIdentifier, forIndexPath: indexPath)
			guard let playCell = cell as? PadPlayCell else { return cell }

			playCell.backgroundColor = pad.color
			playCell.delegate = self

			return playCell

		case .Shift:
			let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Strings.Interface.PadRecordCellReuseIdentifier, forIndexPath: indexPath)
			guard let recordCell = cell as? PadRecordCell else { return cell }

			recordCell.backgroundColor = pad.color
			recordCell.layer.cornerRadius = 10
			recordCell.delegate = self

			return recordCell
		}
	}
}

extension PadsViewController: PadCellDelegate {
	func pad(pad: PadCell, wasTappedWithTouch touch: UITouch) {
		guard let indexPath = self.padsView.indexPathForCell(pad) else { return }
		let coordinates = self.coordinatesForIndex(indexPath.item, wrapAt: Constants.columns)
		self.tapOnPadAtCoordinates(coordinates)
	}

	func pad(pad: PadCell, beganPressWithTouch touch: UITouch) {
		guard let indexPath = self.padsView.indexPathForCell(pad) else { return }
		let coordinates = self.coordinatesForIndex(indexPath.item, wrapAt: Constants.columns)

		if self.mode == .Shift {
			self.session.pads[coordinates] = SimplePad(color: Colors.randomColor()!, audioFile: nil)
			self.workspace.sharedRecorder.record()
		}

		self.padsView.reloadItemsAtIndexPaths([indexPath])
	}

	func pad(pad: PadCell, endedPressWithTouch touch: UITouch) {
		guard let indexPath = self.padsView.indexPathForCell(pad) else { return }
		let coordinates = self.coordinatesForIndex(indexPath.item, wrapAt: Constants.columns)

		if self.mode == .Shift {
			self.session.pads[coordinates]?.audioFile = self.workspace.sharedRecorder.export()
			self.workspace.sharedRecorder = Recorders.make()
		}
	}
}