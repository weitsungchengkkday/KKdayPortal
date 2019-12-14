//
//  LanguageSection.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/14.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxDataSources

struct LanguageSection {
    let header: String
    var items: [Item]
}

extension LanguageSection: AnimatableSectionModelType {
    
    typealias Item = LanguageSettingTableViewCellViewModel
    
    var identity: String {
        return header
    }
    
    init(original: LanguageSection, items: [Item]) {
        self = original
        self.items = items
    }
}
