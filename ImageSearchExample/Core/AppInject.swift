//
//  AppInject.swift
//  ImageSearchExample
//
//  Created by 엄기철 on 2020/10/23.
//

import Swinject

final class AppInject {

	private init() { }

	static let rootContainer: Container = {

		let container = Container()

		container.register(Networking.self) { _ in
			return Networking(logger: [AccessToKenPlugin()])
		}.inObjectScope(.container)

		container.register(ImageSearchRepositoriesProtocol.self) { r in
			return ImageSearchRepositories(networking: r.resolve(Networking.self)!)
		}.inObjectScope(.container)

		container.register(ImageSearchUseCaseProtocol.self) { r in
			return ImageSearchUseCase(searchImageRepository:
				r.resolve(ImageSearchRepositoriesProtocol.self)!)
		}.inObjectScope(.container)

		return container
	}()
}
