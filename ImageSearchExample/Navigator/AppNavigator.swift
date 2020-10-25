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
			guard let service = AppInject.rootContainer.resolve(ImageSearchUseCaseProtocol.self) else {
				return UIViewController()
			}

			let searchImageSection: (Search) -> HomeSection = { items -> HomeSection in

				if items.meta.totalCount > 0 {
					let sectionItems = items.documents.map { item -> SearchImageCellViewModel in
						return SearchImageCellViewModel(items: item)
					}.map(HomeSectionItem.searchImageItem)
					return HomeSection(identity: .image, items: sectionItems)
				} else {
					return HomeSection(identity: .image, items: [])
				}
			}

			let emptySection: (Search) -> HomeSection = { items -> HomeSection in

				if items.meta.totalCount > 0 {
					return HomeSection(identity: .empty, items: [])
				} else {
					return HomeSection(identity: .empty, items: [HomeSectionItem.empty])
				}
			}

			let viewModel: HomeViewModel = HomeViewModel(service: service,
			                                             searchImageSection: searchImageSection,
			                                             emptysection: emptySection)
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
