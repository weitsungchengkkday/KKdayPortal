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

final class SettingViewModel: RXViewModelType {
    
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
    
    func renewToken() {
        
        ModelLoader.PortalLoader()
            .renewToken()
            .subscribeOn(MainScheduler.instance)
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
        
        // Logout from Plone
        ModelLoader.PortalLoader()
            .logout()
            .subscribe(onSuccess: { generalUser in
                debugPrint("👥 Logout -> General User: \(generalUser)")
                
            }) { error in
                debugPrint("🚨 logout -> error is \(error)")}
            .disposed(by: disposeBag)
        
        // Clear UserDefault
        StorageManager.shared.removeAll()
        // Clear WebCache
        WebCacheCleaner.clean()
        
        // FIXME: Note: use coordinator pattern
        let loginController = LoginViewController(viewModel: LoginViewModel())
        Utilities.appDelegateWindow?.rootViewController = loginController
    }
}
