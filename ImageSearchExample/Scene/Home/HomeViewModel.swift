//
//  HomeViewModel.swift
//  ImageSearchExample
//
//  Created 엄기철 on 2020/10/23.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import RxViewBinder

final class HomeViewModel: ViewBindable {

	// MARK: Constants

	private enum Constants {
		static let itemCount: Int = 30
	}

	// MARK: Command

	enum Command {
		case showKeyboard
		case searchKeyword(String)
		case selectedItem(Int)
		case fetchListMore
	}

	// MARK: Action

	struct Action {
		let fetchSearchImageAction: BehaviorRelay<[HomeSection]?> = BehaviorRelay(value: [])
		let showKeyboardAction: PublishRelay<Void> = PublishRelay()
		let moveToDetailImageAction: PublishRelay<SearchImageDTO> = PublishRelay()
		let isNetworkingAction: BehaviorRelay<Bool> = BehaviorRelay(value: false)
	}

	// MARK: State

	struct State {
		let fetchSearchImage: Driver<[HomeSection]?>
		let showKeyboard: Driver<Void>
		let moveToDetailImage: Driver<SearchImageDTO>
		let isNetworking: Driver<Bool>

		init(action: Action) {
			fetchSearchImage = action.fetchSearchImageAction.asDriver(onErrorJustReturn: nil)
			showKeyboard = action.showKeyboardAction.asDriver(onErrorJustReturn: ())
			moveToDetailImage = action.moveToDetailImageAction.asDriver(onErrorJustReturn: SearchImageDTO(imageUrl: "", displaySiteName: "", dateTime: "", width: 0, height: 0))
			isNetworking = action.isNetworkingAction.asDriver(onErrorJustReturn: false)
		}
	}

	// MARK: Factory
	let searchImageSection: (Search) -> HomeSection
	let emptySection: (Search) -> HomeSection

	// MARK: Properties

	var itemMaxCount: Int = 0
	var isEnd: Bool = false
	var searchDTO = PaginationDTO(query: "", page: 1, size: Constants.itemCount)

	var _sections: [HomeSection] = [HomeSection(identity: .image, items: []),
		HomeSection(identity: .empty, items: [])]

	var sections: [HomeSection] {
		get {
			return _sections
		}

		set(newVal) {
			_sections = newVal
		}
	}

	let action = Action()
	lazy var state = State(action: action)

	let service: ImageSearchUseCaseProtocol

	init(service: ImageSearchUseCaseProtocol,
	     searchImageSection: @escaping (Search) -> HomeSection,
	     emptysection: @escaping (Search) -> HomeSection) {
		self.service = service
		self.searchImageSection = searchImageSection
		self.emptySection = emptysection
	}

	deinit {
		print(self)
	}

	func binding(command: Command) {
		switch command {
		case .showKeyboard:
			self.showKeyboard()
		case .searchKeyword(let keyword):
			self.searchImage(keyword)
		case .selectedItem(let index):
			self.itemSelected(index)
		case .fetchListMore:
			loadMoreImageList()
		}
	}

	private func showKeyboard() {
		self.action.showKeyboardAction.accept(())
	}

	private func searchImage(_ keyword: String) {

		let ob = Observable<String>.just(keyword).publish()

		self.searchDTO.query = keyword

		ob.filter { keyword -> Bool in
			return keyword != ""
		}
			.flatMapLatest { _ -> Observable<String> in
				return self.service.searchImage(query: keyword,
				                                size: Constants.itemCount)
			}
			.catchError { error -> Observable<String> in
				let alertActions: [BaseAlertAction] = [.cancel, .ok]
				return AlertService.shared.show(title: "",
				                                message: error.localizedDescription,
				                                preferredStyle: .alert,
				                                actions: alertActions)
					.do(onNext: { [weak self] alertAction in
						switch alertAction {
						case .ok:
							self?.searchImage(keyword)
						case .cancel:
							break
						}
					})
					.flatMap { _ -> Observable<String> in
						return Observable.empty()
				}
			}
			.map { res -> Search in
				return Search(JSONString: res) ?? Search()
			}
			.do(onNext: { [weak self] items in
				self?.itemMaxCount = items.meta.totalCount
				self?.isEnd = items.meta.isEnd
			})
			.map { [weak self] entities -> [HomeSection] in
				guard let self = self else { return [] }

				self.sections = [self.searchImageSection(entities),
					self.emptySection(entities)]

				return self.sections
			}
			.subscribe(onNext: { [weak self] in
				self?.action.fetchSearchImageAction.accept($0)
			})
			.disposed(by: self.disposeBag)

		ob
			.filter { keyword -> Bool in
				return keyword == ""
			}
			.subscribe(onNext: { [weak self] _ in
				guard let self = self else { return }
				self.sections = [HomeSection.init(identity: .image, items: []),
					           HomeSection.init(identity: .empty, items: [])]
				self.action.fetchSearchImageAction.accept(self.sections)
			})
			.disposed(by: self.disposeBag)

		ob.connect().disposed(by: self.disposeBag)
	}

	private func itemSelected(_ target: Int) {

		let cellModel = self.sections[HomeSection.Identity.image.rawValue].items.compactMap { items -> SearchImageCellViewModel? in
			if case let HomeSectionItem.searchImageItem(value) = items {
				return value
			}
			return nil
		}

		let document = cellModel[target].items

		let dto = SearchImageDTO(imageUrl: document.imageUrl,
		                         displaySiteName: document.displaySitename,
		                         dateTime: document.datetime,
		                         width: document.width,
		                         height: document.height)

		self.action.moveToDetailImageAction.accept(dto)
	}

	private func loadMoreImageList() {
		let items = self.sections[HomeSection.Identity.image.rawValue].items

		guard items.count < self.itemMaxCount, items.count != 0, self.isEnd != true else { return }

		guard action.isNetworkingAction.value == false else { return }

		let page = (items.count - Constants.itemCount) / Constants.itemCount + 1

		self.searchDTO.page = page
		let dto = self.searchDTO

		Observable<Int>.timer(.milliseconds(5), scheduler: ConcurrentDispatchQueueScheduler.init(qos: .background))
			.do(onNext: { [weak self] _ in
				self?.action.isNetworkingAction.accept(true)
			})
			.flatMapLatest { [weak self] _ -> Observable<String> in
				guard let self = self else { return .empty() }
				return self.service.loadMoreSearchImage(dto: dto)
			}
			.catchError { error -> Observable<String> in
				let alertActions: [BaseAlertAction] = [.cancel, .ok]
				return AlertService.shared.show(title: "",
				                                message: error.localizedDescription,
				                                preferredStyle: .alert,
				                                actions: alertActions)
					.do(onNext: { [weak self] alertAction in
						switch alertAction {
						case .ok:
							self?.loadMoreImageList()
						case .cancel:
							break
						}
					})
					.flatMap { _ -> Observable<String> in
						return Observable.empty()
				}
			}
			.compactMap { Search(JSONString: $0) }
			.map { ($0.documents, $0.meta.totalCount, $0.meta.isEnd) }
			.do(onNext: { [weak self] items in
				let (_, totalCount, isEnd) = items
				self?.itemMaxCount = totalCount
				self?.isEnd = isEnd
				self?.action.isNetworkingAction.accept(false)
			}, onError: { [weak self] _ in
				self?.action.isNetworkingAction.accept(false)
			})
			.subscribe(onNext: { [weak self] items in
				let (list, _, _) = items
				let cellViewModl = list.map { SearchImageCellViewModel(items: $0) }.map(HomeSectionItem.searchImageItem)

				self?.sections[HomeSection.Identity.image.rawValue].items.append(contentsOf: cellViewModl)
				if let section = self?.sections {
					self?.action.fetchSearchImageAction.accept(section)
				}
			})
			.disposed(by: self.disposeBag)
	}
}
