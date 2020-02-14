//
//  SectionItem.swift
//  KKdayPortal-Sit
//
//  Created by WEI-TSUNG CHENG on 2020/1/17.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import RxDataSources

enum ContentListSectionItem {
    case header(cellViewModel: GeneralRootWithLanguageFoldersHeaderTableViewCellViewModel)
    case normal(cellViewModel: GeneralRootWithLanguageFoldersNormalTableViewCellViewModel)
}

