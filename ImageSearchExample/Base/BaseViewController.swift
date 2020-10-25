//
//  BaseViewController.swift
//  ImageSearchExample
//
//  Created by 엄기철 on 2020/10/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewController


class BaseViewController: UIViewController {

	// MARK: Properties

	private var baseDisposeBag = DisposeBag()

	private(set) var didSetupConstraints = false
	private(set) var didSetupSubViews = false

	// MARK: UI Properties


	// MARK: Initializing

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		print(self)
	}

	// MARK: Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.setNeedsUpdateConstraints()
		self.navigationController?.interactivePopGestureRecognizer?.delegate = self
		self.view.backgroundColor = .white

		self.configureUI()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		if let navi = self.navigationController, navi.viewControllers.first != self {
			self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true

		} else {
			self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
		}
	}

	//뷰컨트롤의 뷰 제약조건을 업데이트 하기 위해 호출
	override func updateViewConstraints() {
		if !self.didSetupConstraints {
			//TODO -- 공통으로 필요한 것을 여기서 생성

			self.setupConstraints()
			self.didSetupConstraints = true
		}
		super.updateViewConstraints()

	}

	//뷰컨트롤러의 뷰가 하위뷰를 표시했음을 알리기 위해 호출
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if !self.didSetupSubViews {
			self.setupSubViews()
			self.didSetupSubViews = true
		}
	}

	// MARK: Func
	func configureUI() { }

	func setupConstraints() { }

	func setupSubViews() { }

	func command() { }

	func state() { }

	override var preferredStatusBarStyle: UIStatusBarStyle {
		if #available(iOS 13.0, *) {
			return .darkContent
		} else {
			return .default
		}
	}
}

extension BaseViewController: UIGestureRecognizerDelegate { }
