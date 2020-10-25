//
//  HomeSection.swift
//  ImageSearchExample
//
//  Created 엄기철 on 2020/10/23.
//  Copyright © 2020 ___ORGANIZATIONNAME___. All rights reserved.
//


import RxDataSources

struct HomeSection {
	enum Identity: Int {
		case image
		case empty
	}
	let identity: Identity
	var items: [HomeSectionItem]
}

extension HomeSection: SectionModelType {
	init(original: HomeSection, items: [HomeSectionItem]) {
		self = .init(identity: original.identity, items: items)
	}
}

enum HomeSectionItem {
	case searchImageItem(SearchImageCellViewModel)
	case empty
}
