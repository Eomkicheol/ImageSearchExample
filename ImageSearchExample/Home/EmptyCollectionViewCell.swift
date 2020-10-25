//
//  EmptyCollectionViewCell.swift
//  ImageSearchExample
//
//  Created 엄기철 on 2020/10/24.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

import RxViewBinder
import SnapKit
import Then

final class EmptyCollectionViewCell: BaseCollectionViewCell {

	// MARK: Constants
	private enum Constants { }

	// MARK: Propertie

	// MARK: UI Properties

	let emptyLabel = UILabel().then {
		$0.text = "검색 결과가 없습니다."
		$0.textAlignment = .center
		$0.textColor = .black
		$0.font = UIFont.boldSystemFont(ofSize: 20)
	}


	// MARK: Initializing

	override func prepareForReuse() {
		super.prepareForReuse()
	}

	// MARK: Constraints

	override func configureUI() {
		super.configureUI()

		[emptyLabel].forEach {
			self.contentView.addSubview($0)
		}
	}

	override func setupConstraints() {
		super.setupConstraints()

		emptyLabel.snp.makeConstraints {
			$0.center.equalToSuperview()
		}
	}
}
