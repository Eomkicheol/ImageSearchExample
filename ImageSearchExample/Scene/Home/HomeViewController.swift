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

	typealias SearchImageSection = RxCollectionViewSectionedReloadDataSource<HomeSection>

	// MARK: Constants
	private enum Constants { }

	// MARK: Properties
	let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

	enum Reusable {
		static let imageCell = ReusableCell<SearchImageCollectionViewCell>()
		static let emptyCell = ReusableCell<EmptyCollectionViewCell>()
	}

	let dataSource: SearchImageSection = SearchImageSection(configureCell: { dataSource, collectionView, indexPath, item -> UICollectionViewCell in
		switch item {
		case .searchImageItem(let viewModel):
			let cell = collectionView.dequeue(Reusable.imageCell, for: indexPath)
			cell.configure(viewBinder: viewModel)
			return cell

		case .empty:
			let cell = collectionView.dequeue(Reusable.emptyCell, for: indexPath)
			cell.configure()
			return cell
		}

	})

	// MARK: UI Properties

	let searchBar = UISearchBar().then {
		$0.setImage(UIImage(), for: .search, state: .normal)
		$0.placeholder = "검색어를 입력해 주세요."
	}

	lazy var searchBaContainerView = SearchBarContainerView(customSearchBar: searchBar).then {
		$0.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
	}

	lazy var collectionView = UICollectionView(frame: .zero,
	                                           collectionViewLayout: self.flowLayout).then { view in
		self.flowLayout.scrollDirection = .vertical
		self.flowLayout.minimumInteritemSpacing = 0.0

		view.backgroundColor = UIColor(red: 242 / 255, green: 242 / 255, blue: 243 / 255, alpha: 1.0)
		view.contentInset.bottom = 80
		view.showsVerticalScrollIndicator = false
		view.showsHorizontalScrollIndicator = false
		view.keyboardDismissMode = .onDrag
		view.contentInsetAdjustmentBehavior = .never
		view.register(Reusable.imageCell)
		view.register(Reusable.emptyCell)
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
			$0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
			$0.left.right.bottom.equalToSuperview()
		}
	}

	// MARK: Command

	func command(viewBinder: HomeViewModel) {
		super.command()

		self.rx.viewDidAppear
			.map { _ in ViewBinder.Command.showKeyboard }
			.bind(to: viewBinder.command)
			.disposed(by: self.disposeBag)

		self.searchBar.rx.text.changed
			.debounce(.seconds(1), scheduler: MainScheduler.instance)
			.map({ keyword -> ViewBinder.Command in
				return ViewBinder.Command.searchKeyword(keyword ?? "")
			})
			.bind(to: viewBinder.command)
			.disposed(by: self.disposeBag)

		collectionView.rx.itemSelected
			.throttle(.milliseconds(5), scheduler: MainScheduler.instance)
			.map { indexPath -> ViewBinder.Command in
				return ViewBinder.Command.selectedItem(indexPath.row)
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

		viewBinder.state
			.fetchSearchImage
			.do(onNext: { [weak self] _ in
				self?.searchBar.resignFirstResponder()
			})
			.drive(collectionView.rx.items(dataSource: dataSource))
			.disposed(by: self.disposeBag)

		viewBinder.state
			.moveToDetailImage
			.drive(onNext: { [weak self] dto in
				self?.navigationController?.pushViewController(AppNavigator.detail(dto: dto).viewController, animated: true)
			})
			.disposed(by: self.disposeBag)
	}

	private func configureNavigationBar() {
		self.navigationItem.titleView = searchBaContainerView
	}
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		let width = collectionView.bounds.width

		switch dataSource[indexPath] {
		case .searchImageItem:
			return SearchImageCollectionViewCell.size(width: (width / 3) - 8 - 8)
		case .empty:
			return .init(width: width, height: collectionView.bounds.height)
		}
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		switch dataSource[section].identity {
		case .image:
			return 16.0
		case .empty:
			return 0.0
		}
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		switch dataSource[section].identity {
		case .image:
			return .init(top: 0, left: 8, bottom: 0, right: 8)
		case .empty:
			return .init(top: 0, left: 0, bottom: 0, right: 0)
		}
	}
}
