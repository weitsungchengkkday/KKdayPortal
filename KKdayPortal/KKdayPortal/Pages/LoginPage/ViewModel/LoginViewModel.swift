//
//  LoginViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/26.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

final class LoginViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()

    var input: LoginViewModel.Input
    var output: LoginViewModel.Output
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init() {
        self.input = Input()
        self.output = Output()
    }
}
