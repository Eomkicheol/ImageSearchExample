//
//  Enviroment.swift
//  ImageSearchExample
//
//  Created by 엄기철 on 2020/10/23.
//

import Foundation

public final class Enviroment {

	public static let baseHost = "https://dapi.kakao.com"

	public static let baseURL: URL = {
		var component = URLComponents(string: baseHost)
		component?.path = "/v2/search/web"
		let url = component?.url
		return url!
	}()

	public static let kakaoKey: String = {
		return "cd28eff5453b4711aaf1b4bfe08245ac"
	}()
}
