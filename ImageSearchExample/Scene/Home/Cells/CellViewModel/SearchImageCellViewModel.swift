//
//  SearchImageCellViewModel.swift
//  ImageSearchExample
//
//  Created by 엄기철 on 2020/10/24.
//

import RxSwift
import RxCocoa
import RxViewBinder

final class SearchImageCellViewModel: ViewBindable {

	// MARK: Constants

	private enum Constants { }

	// MARK: Command

	enum Command { }

	// MARK: Action

	struct Action {
		let configureImageAction: BehaviorRelay<Documents> = BehaviorRelay(value: .init())
	}

	// MARK: State

	struct State {
		let configureImage: Driver<Documents>

		init(action: Action) {
			configureImage = action.configureImageAction.asDriver(onErrorJustReturn: .init())
		}
	}

	// MARK: Properties

	let items: Documents

	init(items: Documents) {
		self.items = items

		self.setup(items)
	}

	let action = Action()
	lazy var state = State(action: action)

	deinit {
		print(self)
	}


	func binding(command: Command) { }

	private func setup(_ item: Documents) {
		self.action.configureImageAction.accept(item)
	}
}

