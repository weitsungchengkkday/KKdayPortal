//
//  Signiner.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/11/12.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import DolphinHTTP

protocol SigninDelegate: AnyObject {
    func signinSuccess(_ signiner: Signiner, generalUser user: GeneralUser)
    func signinFailed(_ signiner: Signiner, signinError error: DolphinHTTP.HTTPError)
}

final class Signiner {
    
    weak var delegate: SigninDelegate?
    
    func signin(url: URL, account: String, password: String) {

        let sessionLoader = URLSessionLoader()
        let api = PloneAPI(loader: sessionLoader)
        
        api.signin(url: url, account: account, password: password) { [weak self] generalUserResult in
            
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                switch generalUserResult {
                case .success(let generalUser):
                    self?.delegate?.signinSuccess(strongSelf, generalUser: generalUser)
                    
                case .failure(let error):
                    self?.delegate?.signinFailed(strongSelf, signinError: error)
                    return
                }
            }
            
        }
    }
    
}


