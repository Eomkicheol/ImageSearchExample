//
//  AppNavigator.swift
//  ImageSearchExample
//
//  Created by 엄기철 on 2020/10/23.
//

import UIKit

enum AppNavigator {
	case home
	case networkingConnection
}

extension AppNavigator {
	var viewController: UIViewController {
		switch self {
		case .home:
			let viewModel: HomeViewModel = HomeViewModel()
			let viewController: HomeViewController = HomeViewController(viewBinder: viewModel)
			let navigationController: UINavigationController = UINavigationController(rootViewController: viewController)
			return navigationController

		case .networkingConnection:
			let viewModel: NetworkingConnectionErrorViewModel = NetworkingConnectionErrorViewModel()
			let viewController: NetworkingConnectionErrorViewController = NetworkingConnectionErrorViewController(viewBinder: viewModel)
			return viewController
		}
	}
}
