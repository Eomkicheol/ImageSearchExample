//
//  ImageSearchRepositories.swift
//  ImageSearchExample
//
//  Created by 엄기철 on 2020/10/24.
//

import RxSwift
import RxCocoa


protocol ImageSearchRepositoriesProtocol: class {
	func searchImage(query: String) -> Observable<String>
}

final class ImageSearchRepositories: ImageSearchRepositoriesProtocol {

	private let networking: NetworkingProtocol

	init(networking: NetworkingProtocol) {
		self.networking = networking
	}

	func searchImage(query: String) -> Observable<String> {
		return networking.request(SearchImageAPI.search(query: query))
			.asObservable()
			.mapString()
			.flatMap { data -> Observable<String> in
				return Observable.just(data)
		}
	}
}
