//
//  AlertServiceType.swift
//  ImagesearchExample
//
//  Created by 엄기철 on 2020/10/25.
//  Copyright © 2020 엄기철. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

protocol AlertServiceType: class {
	func show<Action: AlertActionType>(
		title: String?,
		message: String?,
		preferredStyle: UIAlertController.Style,
		actions: [Action]
	) -> Observable<Action>
}

protocol AlertActionType {
	var title: String? { get }
	var style: UIAlertAction.Style { get }
}

extension AlertActionType {
	var style: UIAlertAction.Style {
		return .default
	}
}
