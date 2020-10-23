//
//  HomeViewController.swift
//  ImageSearchExample
//
//  Created 엄기철 on 2020/10/23.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxViewBinder
import RxDataSources
import ReusableKit
import Then
import SnapKit

final class HomeViewController: BaseViewController, BindView {

	typealias ViewBinder = HomeViewModel

	// MARK: Constants
	private enum Constants { }

	// MARK: Properties
	let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()


	// MARK: UI Properties

	lazy var searchBaContainerView = SearchBarContainerView(customSearchBar: searchBar).then {
		$0.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
	}

	let searchBar = UISearchBar().then {
		$0.setImage(UIImage(), for: .search, state: .normal)
		$0.placeholder = "검색어를 입력해 주세요."
	}

	lazy var collectionView = UICollectionView(frame: .zero,
	                                           collectionViewLayout: self.flowLayout).then { view in
		self.flowLayout.scrollDirection = .vertical
		self.flowLayout.minimumLineSpacing = 0.0
		self.flowLayout.minimumInteritemSpacing = 0.0
		self.flowLayout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)

		view.backgroundColor = UIColor(red: 242 / 255, green: 242 / 255, blue: 243 / 255, alpha: 1.0)
		view.showsVerticalScrollIndicator = false
		view.showsHorizontalScrollIndicator = false
		view.keyboardDismissMode = .onDrag
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
		self.configureNavigationBar()
	}

	// MARK: Constraints

	override func configureUI() {
		super.configureUI()

		[collectionView].forEach {
			self.view.addSubview($0)
		}
	}

	override func setupConstraints() {
		super.setupConstraints()

		collectionView.snp.makeConstraints {
			$0.edges.equalToSuperview()
		}
	}

	// MARK: Command

	func command(viewBinder: HomeViewModel) {
		super.command()

		self.rx.viewDidAppear
			.map { _ in ViewBinder.Command.showKeyboard }
			.bind(to: viewBinder.command)
			.disposed(by: self.disposeBag)

		self.searchBar.rx.text
			.orEmpty
			.distinctUntilChanged()
			.debounce(.seconds(1), scheduler: MainScheduler.instance)
			.map { keyword -> ViewBinder.Command in
				return ViewBinder.Command.searchKeyword(keyword)
			}
			.bind(to: viewBinder.command)
			.disposed(by: self.disposeBag)
	}

	// MARK: State

	func state(viewBinder: HomeViewModel) {
		super.state()

		collectionView.rx.setDelegate(self).disposed(by: self.disposeBag)

		viewBinder.state
			.showKeyboard
			.drive(onNext: { [weak self] in
				self?.searchBar.becomeFirstResponder()
			})
			.disposed(by: self.disposeBag)
	}

	private func configureNavigationBar() {
		self.title = "이미지 검색"
		self.navigationItem.titleView = searchBaContainerView
	}
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return .init(width: collectionView.bounds.width, height: 100)
	}
}
