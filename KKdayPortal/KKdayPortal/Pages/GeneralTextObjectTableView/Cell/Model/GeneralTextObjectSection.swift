//
//  CollectionContentSection.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/31.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import RxDataSources

struct GeneralTextObjectSection {
    let header: String
    var items: [Item]
}

extension GeneralTextObjectSection: SectionModelType {
    
    typealias Item = GeneralTextObjectSectionItem
    var identity: String {
        return header
    }
    
    init(original: Self, items: [Self.Item]) {
        self = original
        self.items = items
    }
}

