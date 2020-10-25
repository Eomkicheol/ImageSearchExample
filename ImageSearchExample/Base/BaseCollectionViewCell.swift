//
//  BaseCollectionViewCell.swift
//  ImageSearchExample
//
//  Created by 엄기철 on 2020/10/23.
//

import UIKit

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {

	private(set) var didSetupConstraints = false

	// MARK: Initialization
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.configureUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Func

	override func updateConstraints() {
		if !self.didSetupConstraints {
			self.setupConstraints()
			self.didSetupConstraints = true
		}
		super.updateConstraints()
	}

	func configure() {
		self.setNeedsUpdateConstraints()
	}

	func configureUI() {
		self.contentView.backgroundColor = .white
	}

	func setupConstraints() { }
}
