//
//  Search.swift
//  ImageSearchExample
//
//  Created by 엄기철 on 2020/10/23.
//

import ObjectMapper

struct Search: Mappable {

	var meta: Meta
	var documents: Documents

	init() {
		meta = Meta()
		documents = Documents()
	}

	init?(map: Map) {
		meta = Meta()
		documents = Documents()
	}

	mutating func mapping(map: Map) {
		meta <- map["meta"]
		documents <- map["documents"]
	}
}

struct Meta: Mappable {

	var isEnd: Bool
	var pageableCount: Int
	var totalCount: Int

	init() {
		isEnd = false
		pageableCount = 0
		totalCount = 0
	}

	init?(map: Map) {
		isEnd = false
		pageableCount = 0
		totalCount = 0
	}

	mutating func mapping(map: Map) {
		isEnd <- map["is_end"]
		pageableCount <- map["pageable_count"]
		totalCount <- map["total_count"]
	}
}


struct Documents: Mappable {

	var collection: String
	var datetime: String
	var displaySitename: String
	var docUrl: String
	var height: Int
	var imageUrl: String
	var thumbnailUrl: String
	var width: Int

	init() {
		collection = ""
		datetime = ""
		displaySitename = ""
		docUrl = ""
		height = 0
		imageUrl = ""
		thumbnailUrl = ""
		width = 0
	}

	init?(map: Map) {
		collection = ""
		datetime = ""
		displaySitename = ""
		docUrl = ""
		height = 0
		imageUrl = ""
		thumbnailUrl = ""
		width = 0
	}

	mutating func mapping(map: Map) {
		collection <- map["collection"]
		datetime <- map["datetime"]
		displaySitename <- map["display_sitename"]
		docUrl <- map["doc_url"]
		height <- map["height"]
		imageUrl <- map["image_url"]
		thumbnailUrl <- map["thumbnail_url"]
		width <- map["width"]
	}
}
