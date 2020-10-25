//
//  AlertService.swift
//  ImagesearchExample
//
//  Created by 엄기철 on 2020/10/25.
//  Copyright © 2020 엄기철. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

final class AlertService: AlertServiceType {

	static let shared: AlertService = AlertService()

	private init() { }

	func show<Action>(title: String?, message: String?, preferredStyle: UIAlertController.Style, actions: [Action]) -> Observable<Action> where Action: AlertActionType {
		return Observable.create { observer -> Disposable in
			let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

			let messageAttributedString = NSAttributedString(string: message ?? "", attributes: [
				NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
				NSAttributedString.Key.foregroundColor: UIColor(red: 44 / 255, green: 55 / 255, blue: 68 / 255, alpha: 1.0)
			])

			let titleAttributedString = NSAttributedString(string: title ?? "", attributes: [
				NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
				NSAttributedString.Key.foregroundColor: UIColor(red: 44 / 255, green: 55 / 255, blue: 68 / 255, alpha: 1.0)])


			for action in actions {
				let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
					observer.onNext(action)
					observer.onCompleted()
				}

				alert.addAction(alertAction)
			}

			alert.setValue(titleAttributedString, forKey: "attributedTitle")
			alert.setValue(messageAttributedString, forKey: "attributedMessage")

			if let topView = UIApplication.topViewController() {
				DispatchQueue.main.async {
					topView.present(alert, animated: true, completion: nil)
				}
			}

			return Disposables.create {
				alert.dismiss(animated: true, completion: nil)
			}
		}
	}

}
