//
//  Loginer.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/21.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift

protocol LoginDelegate: AnyObject {
    func loginSuccess(_ loginer: Loginer, generalUser info: GeneralUser)
    func loginFailed(_ loginer: Loginer, loginError error: Error)
}

final class Loginer {
    
    weak var delegate: LoginDelegate?
    let disposeBag: DisposeBag = DisposeBag()
    
    func login(url: URL, account: String, password: String) {
        ModelLoader.PortalLoader()
            .login(account: account, password: password)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] generalUser in
                
                guard let strongSelf = self else {
                    return
                }
                strongSelf.delegate?.loginSuccess(strongSelf, generalUser: generalUser)
                
            }, onError: { [weak self] error in
                
                guard let strongSelf = self else {
                    return
                }
                strongSelf.delegate?.loginFailed(strongSelf, loginError: error)
            })
        .disposed(by: disposeBag)
       
    }
    
    
}
