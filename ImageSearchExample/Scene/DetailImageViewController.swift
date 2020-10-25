//
//  DetailImageViewController.swift
//  ImagesearchExample
//
//  Created 엄기철 on 2020/10/25.
//  Copyright © 2020 엄기철. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxViewBinder
import RxDataSources
import ReusableKit
import Then
import SnapKit

final class DetailImageViewController: BaseViewController, BindView {

	typealias ViewBinder = DetailImageViewModel

	// MARK: Constants
	private enum Constants { }

	// MARK: Properties
	var dto: SearchImageDTO


	// MARK: UI Properties

	let scrollView = UIScrollView().then {
		$0.contentInsetAdjustmentBehavior = .never
	}

	let contentView = UIView()

	let imageView = CustomImageView()


	// MARK: Initializing
	init(viewBinder: ViewBinder, dto: SearchImageDTO) {
		self.dto = dto
		defer {
			self.viewBinder = viewBinder
		}
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: View Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		self.imageView.setURL(urlName: self.dto.imageUrl,
							  dateTime: self.dto.dateTime,
							  siteName: self.dto.displaySiteName)
	}

	// MARK: Constraints

	override func configureUI() {
		super.configureUI()

		[scrollView].forEach {
			self.view.addSubview($0)
		}

		[contentView].forEach {
			self.scrollView.addSubview($0)
		}

		[imageView].forEach {
			contentView.addSubview($0)
		}
	}

	override func setupConstraints() {
		super.setupConstraints()

		scrollView.snp.makeConstraints {
			$0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
			$0.left.right.bottom.equalToSuperview()
		}

		contentView.snp.makeConstraints {
			$0.edges.equalToSuperview()
			$0.width.equalToSuperview()
			$0.height.equalToSuperview().priority(1)
		}

		imageView.snp.makeConstraints {
			$0.edges.equalToSuperview()
			$0.height.equalTo(imageView.snp.width).multipliedBy(self.dto.ratio)
		}
	}

	// MARK: Command

	func command(viewBinder: DetailImageViewModel) {
		super.command()
	}

	// MARK: State

	func state(viewBinder: DetailImageViewModel) {
		super.state()
	}
}
