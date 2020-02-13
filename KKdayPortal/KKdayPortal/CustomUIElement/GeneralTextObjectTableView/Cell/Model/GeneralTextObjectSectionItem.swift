//
//  CollectionContentSectionItem.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/31.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import RxDataSources

enum GeneralTextObjectSectionItem {
    case normal(cellViewModel: GeneralTextObjectNormalTableViewCellViewModel)
    case iframe(cellViewModel: GeneralTextObjectIFrameTableViewCellViewModel)
    case image(cellViewModel: GeneralTextObjectImageTableViewCellViewModel)
}
