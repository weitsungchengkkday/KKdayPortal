//
//  TestingViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/20.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

final class TestingViewModel {
    
    typealias CellViewModel = TestingTableViewCellViewModel
    
    private(set) var testingItems: [TestingSection] = []
    
    init() {}
    
    func loadTestingItems() {
       
        var testingTableViewCellViewModels: [TestingTableViewCellViewModel] = []
        
        let configModel: ConfigModel = ConfigManager.shared.odooModel
        
        let currentServer: String = configModel.host
        let sitServer: String = configModel.sitServer
        let productionServer: String = configModel.productionServer
        
        testingTableViewCellViewModels.append(TestingTableViewCellViewModel(name: "Sit Server", host: sitServer, serverEnv: .sit, isSelected: sitServer == currentServer))
        testingTableViewCellViewModels.append(TestingTableViewCellViewModel(name: "Production Server", host: productionServer, serverEnv: .production, isSelected: productionServer == currentServer))
        
        self.testingItems = [TestingSection(header: "Testing", items: testingTableViewCellViewModels)]
    }
    
}
