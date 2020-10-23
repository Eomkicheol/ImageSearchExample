//
//  Conversion.swift
//  ImageSearchExample
//
//  Created by 엄기철 on 2020/10/23.
//

import ObjectMapper

struct Conversion: Mappable {
	var errorType: String
	var message: String

	init() {
		errorType = ""
		message = ""
	}

	init?(map: Map) {
		errorType = ""
		message = ""
	}

	mutating func mapping(map: Map) {
		errorType <- map["errorType"]
		message <- map["message"]
	}
}
