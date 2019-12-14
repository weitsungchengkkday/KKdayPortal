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

final class LoginViewModel: RXViewModelType {
    
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
    
    func login(account: String, password: String) {
        
        ModelLoader.PortalLoader()
            .login(account: account, password: password)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { generalUser in
                StorageManager.shared.saveObject(for: .generalUser, value: generalUser)
                debugPrint("👥 Login -> General User: \(generalUser)")
                
            }) { error in
                debugPrint("🚨 Login -> error is \(error)") }
            .disposed(by: disposeBag)
        
    }
}
