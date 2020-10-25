//
//  SearchImageDTO.swift
//  ImageSearchExample
//
//  Created by 엄기철 on 2020/10/25.
//

import Foundation
import UIKit

struct SearchImageDTO {
	var imageUrl: String
	var displaySiteName: String
	var dateTime: String
	var width: CGFloat
	var height: CGFloat
	var ratio: CGFloat {
		return height / width
	}

	init(imageUrl: String,
		 displaySiteName: String,
		 dateTime: String,
		 width: CGFloat,
		 height: CGFloat) {
		self.imageUrl = imageUrl
		self.displaySiteName = displaySiteName
		self.dateTime = dateTime
		self.width = width
		self.height = height
	}
}
