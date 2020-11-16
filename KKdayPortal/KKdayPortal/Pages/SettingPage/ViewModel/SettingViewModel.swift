//
//  SettingViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/15.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa
import WebKit

final class SettingViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    var input: SettingViewModel.Input
    var output: SettingViewModel.Output
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init() {
        self.input = Input()
        self.output = Output()
    }

    
    func logout() {
        MemberManager.shared.logout()
    }
}
