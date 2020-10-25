//
//  ImageSearchUseCase.swift
//  ImageSearchExample
//
//  Created by 엄기철 on 2020/10/24.
//

import RxCocoa
import RxSwift

protocol ImageSearchUseCaseProtocol: class {
	func searchImage(query: String) -> Observable<String>
}

final class ImageSearchUseCase: ImageSearchUseCaseProtocol {

	private let searchImageRepository: ImageSearchRepositoriesProtocol

	init(searchImageRepository: ImageSearchRepositoriesProtocol) {
		self.searchImageRepository = searchImageRepository
	}

	func searchImage(query: String) -> Observable<String> {
		return self.searchImageRepository.searchImage(query: query)
	}
}
