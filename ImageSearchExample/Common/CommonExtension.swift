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

// MARK: - Dictionary
extension Dictionary {
	mutating func merge(dict: [Key: Value]) {
		for (key, value) in dict {
			updateValue(value, forKey: key)
		}
	}
}

// MARK: - 최상위 뷰컨
extension UIApplication {
	static func topViewController(ViewController: UIViewController? =
									UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

		if let tabBarViewController = ViewController as? UITabBarController {
			if let vc = tabBarViewController.selectedViewController {
				return topViewController(ViewController: vc)
			}
		}

		if let navigationViewController = ViewController as? UINavigationController {
			if let vc = navigationViewController.visibleViewController {
				return topViewController(ViewController: vc)
			}
		}

		if let presentedViewController = ViewController?.presentedViewController {
			return topViewController(ViewController: presentedViewController)
		}



		return ViewController
	}
}


