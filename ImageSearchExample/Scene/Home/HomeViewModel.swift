//
//  HomeViewModel.swift
//  ImageSearchExample
//
//  Created 엄기철 on 2020/10/23.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

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
	}

	// MARK: Action

	struct Action {
		let showKeyboardAction: PublishRelay<Void> = PublishRelay()
	}

	// MARK: State

	struct State {
		let showKeyboard: Driver<Void>

		init(action: Action) {
			showKeyboard = action.showKeyboardAction.asDriver(onErrorJustReturn: ())
		}
	}

	// MARK: Properties

	let action = Action()
	lazy var state = State(action: action)

	deinit {
		print(self)
	}

	func binding(command: Command) {
		switch command {
		case .showKeyboard:
			self.showKeyboard()
			case .searchKeyword(let keyword):
				print(keyword)
		}
	}

	private func showKeyboard() {
		self.action.showKeyboardAction.accept(())
	}
}
