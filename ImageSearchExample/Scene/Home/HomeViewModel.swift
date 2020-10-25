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

	private enum Constants { }

	// MARK: Command

	enum Command {
		case showKeyboard
		case searchKeyword(String)
		case selectedItem(Int)
	}

	// MARK: Action

	struct Action {
		let fetchSearchImageAction: BehaviorRelay<[HomeSection]> = BehaviorRelay(value: [])
		let showKeyboardAction: PublishRelay<Void> = PublishRelay()
		let moveToDetailImageAction: PublishRelay<SearchImageDTO> = PublishRelay()
	}

	// MARK: State

	struct State {
		let fetchSearchImage: Driver<[HomeSection]>
		let showKeyboard: Driver<Void>
		let moveToDetailImage: Driver<SearchImageDTO>

		init(action: Action) {
			fetchSearchImage = action.fetchSearchImageAction.asDriver(onErrorJustReturn: [])
			showKeyboard = action.showKeyboardAction.asDriver(onErrorJustReturn: ())
			moveToDetailImage = action.moveToDetailImageAction.asDriver(onErrorJustReturn: SearchImageDTO(imageUrl: "", displaySiteName: "", dateTime: "", width: 0, height: 0))
		}
	}

	// MARK: Factory
	let searchImageSection: (Search) -> HomeSection
	let emptySection: (Search) -> HomeSection

	// MARK: Properties

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
		}
	}

	private func showKeyboard() {
		self.action.showKeyboardAction.accept(())
	}

	private func searchImage(_ keyword: String) {


		let ob = Observable<String>.just(keyword).publish()


		ob.filter { keyword -> Bool in
			return keyword != ""
		}
			.flatMap { _ -> Observable<String> in
				return self.service.searchImage(query: keyword)
			}
			.map { res -> Search in
				return Search(JSONString: res) ?? Search()
			}
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
}
