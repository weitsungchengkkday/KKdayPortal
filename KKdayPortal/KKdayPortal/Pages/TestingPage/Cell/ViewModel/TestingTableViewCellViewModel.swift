//
//  TestingTableViewCellViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/20.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

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
