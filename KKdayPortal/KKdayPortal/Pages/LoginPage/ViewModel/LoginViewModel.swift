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
        let ploneLogin = PortalUser.Login(account: account, password: password)
        let response = apiManager.request(ploneLogin)
        
        response
            .subscribe(onSuccess: { authToken in
                print("🎫 Plone authToken: \(authToken.token)")
                let user = PloneUser(account: account, token: authToken.token)
                StorageManager.shared.saveObject(for: .ploneUser, value: user)
            }) { error in
                print("🚨 Login error is \(error)")
        }
        .disposed(by: disposeBag)
    }
    
    func renewToken() {
        let user: PloneUser? = StorageManager.shared.loadObject(for: .ploneUser)
        let renewToken = PortalUser.RenewToken(user: user)
        let response = apiManager.request(renewToken)
        
        response
            .subscribe(onSuccess: { authToken in
                print("🎫 Renew authToken: \(authToken.token)")
                
                let renewToken = authToken.token
                
                if let user: PloneUser = StorageManager.shared.load(for: .ploneUser) {
                    let renewUser = PloneUser(account: user.account, token: renewToken)
                    StorageManager.shared.save(for: .ploneUser, value: renewUser)
                }
                
            }) { error in
                print("🚨 Renew token error is \(error)")
        }
        .disposed(by: disposeBag)
    }
    
}
