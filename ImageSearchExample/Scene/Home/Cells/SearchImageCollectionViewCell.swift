//
//  SearchImageCollectionViewCell.swift
//  ImageSearchExample
//
//  Created 엄기철 on 2020/10/23.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxViewBinder
import SnapKit
import Then
import Kingfisher

final class SearchImageCollectionViewCell: BaseCollectionViewCell, BindCell {

	typealias ViewBinder = SearchImageCellViewModel

	// MARK: Constants
	private enum Constants {
		static let imageHeight: CGFloat = 100
	}

	// MARK: Propertie

	var disposeBag: DisposeBag = DisposeBag()


	// MARK: UI Properties

	let imageView = UIImageView().then { view in
		view.contentMode = .scaleToFill
		view.clipsToBounds = true
		view.backgroundColor = .lightGray
	}


	// MARK: Initializing

	override func prepareForReuse() {
		super.prepareForReuse()
	}

	func configure(viewBinder: ViewBinder) {
		super.configure()
		self.viewBinder = viewBinder
	}


	// MARK: Constraints

	override func configureUI() {
		super.configureUI()

		[imageView].forEach {
			self.contentView.addSubview($0)
		}
	}

	override func setupConstraints() {
		super.setupConstraints()

		imageView.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
	}

	// MARK: Command

	func command(viewBinder: SearchImageCellViewModel) { }

	// MARK: State

	func state(viewBinder: SearchImageCellViewModel) {
		viewBinder.state
			.configureImage
			.drive(onNext: { [weak self] items in
				if let url = URL(string: items.thumbnailUrl) {
					self?.imageView.kf.setImage(with: url, options: [.cacheMemoryOnly,
																	 .transition(.fade(0.2))])
				}
			})
			.disposed(by: self.disposeBag)
	}

	static func size(width: CGFloat) -> CGSize {
		let height: CGFloat = Constants.imageHeight
		return CGSize(width: width, height: height)
	}
}
