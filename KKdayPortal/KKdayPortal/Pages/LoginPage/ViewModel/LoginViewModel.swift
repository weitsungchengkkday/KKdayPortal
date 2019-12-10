//
//  LoginViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/26.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class LoginViewModel: RXViewModelType {
    
    var apiManager: APIManager
    let disposeBag = DisposeBag()
    
    var input: LoginViewModel.Input
    var output: LoginViewModel.Output
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init(apiManager: APIManager) {
        self.apiManager = apiManager
        self.input = Input()
        self.output = Output()
    }
    
    func login(account: String, password: String) {
        
        ModelLoader.PortalLoader()
            .login(account: account, password: password)
            .subscribe(onSuccess: { generalUser in
                StorageManager.shared.saveObject(for: .generalUser, value: generalUser)
                debugPrint("👥 Login -> General User: \(generalUser)")
                
            }) { error in
                debugPrint("🚨 Login -> error is \(error)") }
            .disposed(by: disposeBag)
        
    }
    
    func renewToken() {
        
        ModelLoader.PortalLoader()
            .renewToken()
            .subscribe(onSuccess: { generalUser in
                guard let generalUser = generalUser else {
                    return
                }
                debugPrint("👥 Renew Token -> General User: \(generalUser)")
                
            }) { error in
                debugPrint("🚨 Renew Token -> error is \(error)")}
            .disposed(by: disposeBag)
    }
    
    func logout() {
        
        ModelLoader.PortalLoader()
            .logout()
            .subscribe(onSuccess: { generalUser in
                debugPrint("👥 Logout -> General User: \(generalUser)")
                
            }) { error in
                debugPrint("🚨 Renew Token -> error is \(error)")}
            .disposed(by: disposeBag)
    }
}
