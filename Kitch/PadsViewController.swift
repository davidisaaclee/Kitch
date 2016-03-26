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

	let pressLeftShiftGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
	let pressRightShiftGestureRecognizer: UILongPressGestureRecognizer = UILongPressGestureRecognizer()

	@IBOutlet var padsView: UICollectionView! {
		didSet {
			self.padsView.dataSource = self
			self.padsView.registerClass(PadCell.self, forCellWithReuseIdentifier	: Strings.Interface.PadCellReuseIdentifier)
		}
	}

	@IBOutlet var leftShiftButton: UIView! {
		didSet {
			self.leftShiftButton.addGestureRecognizer(self.pressLeftShiftGestureRecognizer)
		}
	}

	@IBOutlet var rightShiftButton: UIView! {
		didSet {
			self.rightShiftButton.addGestureRecognizer(self.pressRightShiftGestureRecognizer)
		}
	}

	private enum Mode {
		case Normal
		case LeftShift
	}

	private var mode: Mode = .Normal {
		didSet {
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
		self.pressLeftShiftGestureRecognizer.minimumPressDuration = 0
		self.pressLeftShiftGestureRecognizer.addTarget(self, action: #selector(self.pressLeftShift(_:)))

		self.pressRightShiftGestureRecognizer.minimumPressDuration = 0
		self.pressRightShiftGestureRecognizer.addTarget(self, action: #selector(self.pressRightShift(_:)))
	}

	override func viewDidLoad() {
		guard let flowLayout = self.padsView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

		flowLayout.itemSize = CGSize(width: Int(self.view.bounds.width / 3 + 0.5), height: Int(self.view.bounds.height / 5 + 0.5))
		flowLayout.minimumLineSpacing = 0
		flowLayout.minimumInteritemSpacing = 0

		self.view.backgroundColor = Colors.byName("blackDark")!
	}

	func tapOnPadAtCoordinates(coordinates: Coordinates) {
		if self.mode == .Normal {
			self.session.pads[coordinates].tap { self.workspace.triggerPad($0, session: self.session) }
		}
	}

	@objc private func pressLeftShift(recognizer: UILongPressGestureRecognizer) {
		switch recognizer.state {
		case .Began:
			self.mode = .LeftShift

		case .Ended:
			self.mode = .Normal

		default: return
		}
	}

	@objc private func pressRightShift(recognizer: UILongPressGestureRecognizer) {
		switch recognizer.state {
		case .Began:
			self.performSegueWithIdentifier(Strings.Interface.Segues.ShowSongSettings, sender: self)

		case .Ended:
			self.dismissViewControllerAnimated(false, completion: nil)

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

		self.updatePadCell(padCell, forPad: self.session.pads[self.coordinatesForIndex(indexPath.item, wrapAt: Constants.columns)])
		return padCell
	}

	func updatePadViewAtCoordinates(coordinates: Coordinates) {
		let indexPath = NSIndexPath(forItem: self.indexForCoordinates(coordinates), inSection: 0)
		guard let cell = self.padsView.cellForItemAtIndexPath(indexPath) else { return }
		guard let padCell = cell as? PadCell else { return }

		self.updatePadCell(padCell, forPad: self.session.pads[coordinates])
	}

	func indexForCoordinates(coordinates: Coordinates, wrappedAt: Int = Constants.columns) -> Int {
		return coordinates.x + coordinates.y * wrappedAt
	}

	func updatePadCell(padCell: PadCell, forPad pad: Pad?) {
		if let pad = pad {
			switch self.mode {
			case .Normal:
				padCell.configuration = .CanPlay
				padCell.backgroundColor = pad.color

			case .LeftShift:
				padCell.configuration = .Editing
				padCell.backgroundColor = pad.color
			}
		} else {
			padCell.configuration = .Empty
		}

		padCell.delegate = self
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
				self.session.pads[coordinates] = SimplePad(color: Colors.randomColor()!, audioFileID: nil)
				self.workspace.sharedRecorder.record()
			}

		case .LeftShift:
			break
		}

		self.updatePadViewAtCoordinates(coordinates)
	}

	func pad(pad: PadCell, endedPressWithTouch touch: UITouch) {
		guard let indexPath = self.padsView.indexPathForCell(pad) else { return }
		let coordinates = self.coordinatesForIndex(indexPath.item, wrapAt: Constants.columns)

		guard let pad = self.session.pads[coordinates] else { return }

		if pad.audioFileID == nil {
			let fileID = self.session.bin.addFile(self.workspace.sharedRecorder.export())
			self.session.pads[coordinates]?.audioFileID = fileID
			self.workspace.sharedRecorder = Recorders.make()
		}
	}
}