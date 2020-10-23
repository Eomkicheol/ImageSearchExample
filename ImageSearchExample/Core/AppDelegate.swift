//
//  AppDelegate.swift
//  ImageSearchExample
//
//  Created by 엄기철 on 2020/10/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		self.makeRootViewController()
		return true
	}

	private func makeRootViewController() {
		self.window = UIWindow(frame: UIScreen.main.bounds).then { window in
			window.rootViewController = AppNavigator.home.viewController
			window.backgroundColor = .white
			window.makeKeyAndVisible()
		}
	}
}

