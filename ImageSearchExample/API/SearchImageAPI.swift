//
//  SearchImageAPI.swift
//  ImageSearchExample
//
//  Created by 엄기철 on 2020/10/24.
//

import Moya

enum SearchImageAPI {
	case search(query: String)
}

extension SearchImageAPI: BaseAPI {
	var path: String {
		return "/image"
	}

	var method: Method {
		switch self {
		case .search:
			return .get
		}
	}

	var task: Task {
		guard let parameters = parameters else { return .requestPlain }
		switch self {
		case .search:
			return .requestParameters(parameters: parameters, encoding: parameterEncoding)
		}
	}


	var parameters: [String: Any]? {
		switch self {
		case .search(let query):
			return ["query": query]
		}
	}

	var parameterEncoding: ParameterEncoding {
		switch self {
		case .search:
			return URLEncoding.queryString
		}
	}
}
