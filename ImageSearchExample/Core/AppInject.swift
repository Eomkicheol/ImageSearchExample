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

		return container
	}()
}
