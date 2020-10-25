//
//  BaseAlertAction.swift
//  ImagesearchExample
//
//  Created by 엄기철 on 2020/10/26.
//  Copyright © 2020 엄기철. All rights reserved.
//

import UIKit

enum BaseAlertAction: AlertActionType {
	case ok
	case cancel

	var title: String? {
		switch self {
			case .ok: return "확인"
			case .cancel: return "취소"
		}
	}

	var style: UIAlertAction.Style {
		switch self {
			case .ok: return .default
			case .cancel: return .default
		}
	}
}
