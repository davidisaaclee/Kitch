//
//  PadsViewController.swift
//  Kitch
//
//  Created by David Lee on 3/26/16.
//  Copyright © 2016 David Lee. All rights reserved.
//

import UIKit

class PadsViewController: UIViewController {

	var workspace: Workspace = Workspace()
	var session: Session = Sessions.make()

	let pressShiftGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer()

	@IBOutlet var padsView: UICollectionView! {
		didSet {
			self.padsView.dataSource = self
			self.padsView.registerClass(PadCell.self, forCellWithReuseIdentifier	: Strings.Interface.PadCellReuseIdentifier)
		}
	}

	@IBOutlet var shiftButton: UIView! {
		didSet {
			self.shiftButton.addGestureRecognizer(self.pressShiftGestureRecognizer)
		}
	}

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

	private struct Constants {
		static let rows = 5
		static let columns = 3
	}

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
			self.mode = .Shift

		case .Ended:
			self.mode = .Normal

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
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Strings.Interface.PadCellReuseIdentifier, forIndexPath: indexPath)
		guard let padCell = cell as? PadCell else { return cell }

		guard let pad = self.session.pads[self.coordinatesForIndex(indexPath.item, wrapAt: Constants.columns)] else {
			padCell.delegate = self
			padCell.backgroundColor = UIColor.darkGrayColor()
			return padCell
		}

		self.updatePadCell(padCell, forPad: pad)
		return padCell
	}

	func updatePadViewAtCoordinates(coordinates: Coordinates) {
		let indexPath = NSIndexPath(forItem: self.indexForCoordinates(coordinates), inSection: 0)
		guard let cell = self.padsView.cellForItemAtIndexPath(indexPath) else { return }
		guard let padCell = cell as? PadCell else { return }
		guard let pad = self.session.pads[coordinates] else { return }

		self.updatePadCell(padCell, forPad: pad)
	}

	func indexForCoordinates(coordinates: Coordinates, wrappedAt: Int = Constants.columns) -> Int {
		return coordinates.x + coordinates.y * wrappedAt
	}

	func updatePadCell(padCell: PadCell, forPad pad: Pad) {
		padCell.backgroundColor = pad.color
		padCell.delegate = self
		padCell.layer.cornerRadius = self.mode == .Shift ? 10 : 0
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

		switch self.mode {
		case .Normal:
			if self.session.pads[coordinates] == nil {
				self.session.pads[coordinates] = SimplePad(color: Colors.randomColor()!, audioFile: nil)
				self.workspace.sharedRecorder.record()
			}

		case .Shift:
			break
		}

		if self.mode == .Shift {
		}

		self.updatePadViewAtCoordinates(coordinates)
	}

	func pad(pad: PadCell, endedPressWithTouch touch: UITouch) {
		guard let indexPath = self.padsView.indexPathForCell(pad) else { return }
		let coordinates = self.coordinatesForIndex(indexPath.item, wrapAt: Constants.columns)

		guard let pad = self.session.pads[coordinates] else { return }

		if pad.audioFile == nil {
			self.session.pads[coordinates]?.audioFile = self.workspace.sharedRecorder.export()
			self.workspace.sharedRecorder = Recorders.make()
		}
	}
}