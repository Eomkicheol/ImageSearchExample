//
//  NetworkingConnectionErrorViewController.swift
//  ImageSearchExample
//
//  Created 엄기철 on 2020/10/23.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxViewBinder
import Then
import SnapKit

final class NetworkingConnectionErrorViewController: BaseViewController, BindView {

	typealias ViewBinder = NetworkingConnectionErrorViewModel

	// MARK: Constants
	private enum Constants { }

	// MARK: Properties


	// MARK: UI Properties

	let errorImage = UIImageView(image: UIImage(named: "networkCut")).then { image in
		image.contentMode = .scaleAspectFit
		image.clipsToBounds = true
	}

	let titleLabel = UILabel().then { label in
		label.text = "네트워크 연결 오류예요."
		label.textColor = UIColor(red: 44 / 255, green: 55 / 255, blue: 68 / 255, alpha: 1.0)
		label.font = UIFont.systemFont(ofSize: 16)
		label.textAlignment = .center
	}

	let contentsLabel = UILabel().then { label in
		label.text = "현재 네트워크에 연결되어 있지 않아요.\n확인 후 다시 시도해주세요~"
		label.textColor = UIColor(red: 44 / 255, green: 55 / 255, blue: 68 / 255, alpha: 0.4)
		label.font = UIFont.systemFont(ofSize: 16)
		label.numberOfLines = 0
		label.textAlignment = .center
	}

	let homeButton = UIButton(type: .custom).then { button in
		button.setTitle("홈으로", for: .normal)
		button.setTitleColor(UIColor(red: 44 / 255, green: 55 / 255, blue: 68 / 255, alpha: 1.0), for: .normal)
		button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
		button.titleLabel?.textAlignment = .center
		button.layer.cornerRadius = 8
		button.backgroundColor = UIColor(red: 255 / 255, green: 237 / 255, blue: 73 / 255, alpha: 1.0)
	}


	// MARK: Initializing
	init(viewBinder: ViewBinder) {
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
	}

	// MARK: Constraints

	override func configureUI() {
		super.configureUI()

		[errorImage, titleLabel,
			contentsLabel, homeButton].forEach {
			self.view.addSubview($0)
		}
	}

	override func setupConstraints() {
		super.setupConstraints()

		errorImage.snp.makeConstraints {
			$0.centerX.equalToSuperview()
			$0.height.equalTo(102)
			$0.bottom.equalTo(titleLabel.snp.top).offset(-17)
		}

		titleLabel.snp.makeConstraints {
			$0.centerX.equalToSuperview()
			$0.bottom.equalTo(contentsLabel.snp.top).offset(-14)
		}

		contentsLabel.snp.makeConstraints {
			$0.center.equalToSuperview()
		}

		homeButton.snp.makeConstraints {
			$0.top.equalTo(contentsLabel.snp.bottom).offset(16)
			$0.left.equalToSuperview().offset(98)
			$0.right.equalToSuperview().offset(-97)
			$0.height.equalTo(48)
		}
	}

	// MARK: Command

	func command(viewBinder: NetworkingConnectionErrorViewModel) {
		super.command()

		homeButton.rx.tap
			.throttle(.microseconds(5), scheduler: MainScheduler.instance)
			.map { ViewBinder.Command.moveHome }
			.bind(to: viewBinder.command)
			.disposed(by: self.disposeBag)
	}

	// MARK: State

	func state(viewBinder: NetworkingConnectionErrorViewModel) {
		super.state()

		viewBinder.state
			.moveHome
			.map { UIWindow(frame: UIScreen.main.bounds) }
			.drive(onNext: { window in
				window.switchRootViewController(rootViewController: AppNavigator.home.viewController, animated: true, completion: nil)

			})
			.disposed(by: self.disposeBag)
	}
}
