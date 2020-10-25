//
//  CommonExtension.swift
//  ImageSearchExample
//
//  Created by 엄기철 on 2020/10/23.
//

import UIKit

//MAEK: -- AnimatedChangeRootViewController
extension UIWindow {
	func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
		guard let window = UIApplication.shared.keyWindow else { return }
		if animated {
			UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
				let oldState: Bool = UIView.areAnimationsEnabled
				UIView.setAnimationsEnabled(false)
				window.rootViewController = rootViewController
				UIView.setAnimationsEnabled(oldState)
			}, completion: { _ in
				if completion != nil {
					completion!()
				}
			})
		} else {
			window.rootViewController = rootViewController
		}
	}
}


