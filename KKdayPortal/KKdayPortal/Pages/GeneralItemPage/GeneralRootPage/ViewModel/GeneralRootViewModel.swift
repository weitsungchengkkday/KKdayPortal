//
//  GeneralRootViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/7.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class GeneralRootViewModel: ViewModelType {
    
    typealias PortalContent = GeneralItem
    
    var input: GeneralRootViewModel.Input
    var output: GeneralRootViewModel.Output
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    private let disposeBag = DisposeBag()
    
    init(source: URL) {
        self.input = Input()
        self.output = Output()
    }
    
}
