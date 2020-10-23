//
//  SearchNavigator.swift
//  ImageSearchExample
//
//  Created by 엄기철 on 2020/10/23.
//

import UIKit

enum AppNavigator {
	case home
}


extension AppNavigator {
	var viewController: UIViewController {
		switch self {
		case .home:
			return UIViewController()
		}
	}
}
