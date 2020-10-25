//
//  AccessToKenPlugin.swift
//  ImageSearchExample
//
//  Created by 엄기철 on 2020/10/23.
//

import Foundation

import Moya

final class AccessToKenPlugin: PluginType {
	func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
		var headerRequest = request

		headerRequest.addValue(Enviroment.kakaoKey, forHTTPHeaderField: "Authorization")
		return headerRequest
	}
}
