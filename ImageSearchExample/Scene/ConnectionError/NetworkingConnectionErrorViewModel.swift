//
//  NetworkingConnectionErrorViewModel.swift
//  ImageSearchExample
//
//  Created 엄기철 on 2020/10/23.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import RxSwift
import RxCocoa
import RxViewBinder

final class NetworkingConnectionErrorViewModel: ViewBindable {

	// MARK: Constants

	private enum Constants { }

	// MARK: Command

	enum Command {
		case moveHome
	}

	// MARK: Action

	struct Action {
		let moveHomeAction: PublishRelay<Void> = PublishRelay()
	}

	// MARK: State

	struct State {
		let moveHome: Driver<Void>

		init(action: Action) {
			moveHome = action.moveHomeAction.asDriver(onErrorJustReturn: ())
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
			case .moveHome:
			self.moveToHomeViewController()
		}
	}

	private func moveToHomeViewController() {
		self.action.moveHomeAction.accept(())
	}
}
