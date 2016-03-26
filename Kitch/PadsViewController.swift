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

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self.setup()
	}


	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.setup()
	}

	private func setup() {
		self.session.pads[Coordinates(x: 1, y: 1)] = SimplePad(color: UIColor.redColor())
	}

	override func viewDidLoad() {
		guard let flowLayout = self.padsView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

		flowLayout.itemSize = CGSize(width: self.view.bounds.width / 3, height: self.view.bounds.height / 5)
		flowLayout.minimumLineSpacing = 0
		flowLayout.minimumInteritemSpacing = 0
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
			cell.backgroundColor = UIColor.darkGrayColor()
			return cell
		}

		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Strings.Interface.PadPlayCellReuseIdentifier, forIndexPath: indexPath)
		guard let playCell = cell as? PadPlayCell else { return cell }

		playCell.backgroundColor = pad.color

		return playCell
	}

	private func coordinatesForIndex(index: Int, wrapAt: Int) -> Coordinates {
		return Coordinates(x: index % wrapAt, y: index / wrapAt)
	}
}