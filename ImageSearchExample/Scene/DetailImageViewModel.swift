//
//  DetailImageViewModel.swift
//  ImagesearchExample
//
//  Created 엄기철 on 2020/10/25.
//  Copyright © 2020 엄기철. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import RxViewBinder

final class DetailImageViewModel: ViewBindable {

	// MARK: Constants

	private enum Constants { }

	// MARK: Command

	enum Command {}

	// MARK: Action

	struct Action {}

	// MARK: State

	struct State {
		init(action: Action) {}
	}

	// MARK: Properties

	let action = Action()
	lazy var state = State(action: action)

	deinit {
		print(self)
	}


	func binding(command: Command) {}
}
