//
//  CollectionContentSectionItem.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/31.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

enum GeneralTextObjectSectionItem {
    case normal(cellViewModel: GeneralTextObjectNormalTableViewCellViewModel)
    case iframe(cellViewModel: GeneralTextObjectIFrameTableViewCellViewModel)
    case image(cellViewModel: GeneralTextObjectImageTableViewCellViewModel)
}
