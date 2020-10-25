//
//  SearchImageDTO.swift
//  ImageSearchExample
//
//  Created by 엄기철 on 2020/10/25.
//

import Foundation


struct SearchImageDTO {
	var imageUrl: String
	var displaySiteName: String
	var dateTime: String

	init(imageUrl: String, displaySiteName: String, dateTime: String) {
		self.imageUrl = imageUrl
		self.displaySiteName = displaySiteName
		self.dateTime = dateTime
	}
}
