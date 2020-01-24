//
//  TestingViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/20.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import RxCocoa
import RxSwift

final class TestingViewModel: RXViewModelType {
    
    typealias CellViewModel = TestingTableViewCellViewModel
    
    var input: TestingViewModel.Input
    var output: TestingViewModel.Output
    
    struct Input {
        let cellViewModels: AnyObserver<[TestingSection]>
    }
    
    struct Output {
        let showTestingItems: Driver<[TestingSection]>
    }
    
    private let cellViewModelsSubject = PublishSubject<[TestingSection]>()
    
    init() {
        self.input = Input(cellViewModels: cellViewModelsSubject.asObserver())
        self.output = Output(showTestingItems: cellViewModelsSubject.asDriver(onErrorJustReturn: []))
    }
    
    func nextCellViewModelEvent() {
        cellViewModelsSubject.onNext(getCellViewModels())
    }
    
    func getCellViewModels() -> [TestingSection] {
        
        var testingTableViewCellViewModels: [TestingTableViewCellViewModel] = []
        
        let configModel: ConfigModel = ConfigManager.shared.model
        
        let currentServer: String = configModel.host
        let sitServer: String = configModel.sitServer
        let productionServer: String = configModel.productionServer
        testingTableViewCellViewModels.append(TestingTableViewCellViewModel(name: "Sit Server", host: sitServer, serverType: .sit, isSelected: sitServer == currentServer))
        testingTableViewCellViewModels.append(TestingTableViewCellViewModel(name: "Production", host: productionServer, serverType: .production, isSelected: productionServer == currentServer))
        
        return [TestingSection(header: "Testing", items: testingTableViewCellViewModels)]
    }
}
