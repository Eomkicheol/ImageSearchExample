//
//  ImageSearchRepositories.swift
//  ImageSearchExample
//
//  Created by 엄기철 on 2020/10/24.
//

import RxSwift
import RxCocoa

protocol ImageSearchRepositoriesProtocol: class {
	func searchImage(query: String, size: Int) -> Observable<String>
	func loadMoreSearchImage(dto: PaginationDTO) -> Observable<String>
}

final class ImageSearchRepositories: ImageSearchRepositoriesProtocol {

	private let networking: NetworkingProtocol

	init(networking: NetworkingProtocol) {
		self.networking = networking
	}

	func searchImage(query: String, size: Int) -> Observable<String> {
		return networking.request(SearchImageAPI.search(query: query, size: size))
			.asObservable()
			.mapString()
			.flatMap { data -> Observable<String> in
				return Observable.just(data)
		}
	}

	func loadMoreSearchImage(dto: PaginationDTO) -> Observable<String> {
		return networking.request(SearchImageAPI.loadMoreImage(dto: dto))
			.asObservable()
			.mapString()
			.flatMap { data -> Observable<String> in
				return Observable.just(data)
		}
	}
}
