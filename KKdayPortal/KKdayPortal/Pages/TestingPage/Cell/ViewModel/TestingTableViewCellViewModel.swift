//
//  TestingTableViewCellViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/20.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

final class TestingTableViewCellViewModel {
    
    var name: String
    var host: String
    var serverType: ServerTypes
    var isSelected: Bool
    
    init(name: String, host: String, serverType: ServerTypes, isSelected: Bool) {
        self.name = name
        self.host = host
        self.serverType = serverType
        self.isSelected = isSelected
    }
}

extension TestingTableViewCellViewModel: IdentifiableType, Equatable {
    
    typealias Identity = String
    
    var identity: Identity {
        return serverType.identity
    }
    
    static func == (lhs: TestingTableViewCellViewModel, rhs: TestingTableViewCellViewModel) -> Bool {
        return lhs.identity == rhs.identity
    }
    
}
