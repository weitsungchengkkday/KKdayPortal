//
//  Authorizable.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/9.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa


enum PortalService {
    case plone
}

struct SignInResponse {
    let service: PortalService
    let account: String
    let token: String
}



protocol Authorizable {
    func signIn() -> Single<SignInResponse>
    func sigOut()
}

final class PloneService: Authorizable {
    
    let apiManager = APIManager.default
    let disposeBag = DisposeBag()
    
    var account: String
    var password: String
    
    init(account: String, password: String) {
        self.account = account
        self.password = password
    }
    
    func signIn() -> Single<SignInResponse> {
        let signInRequest = PortalUser.Login(account: account, password: password)
        
        let response = apiManager.request(signInRequest)
            .map {[weak self] ploneAuthToken -> SignInResponse in
                
                guard let a = self else { return SignInResponse(service: <#T##PortalService#>, account: <#T##String#>, token: <#T##String#>)
                    
                }
                
                return SignInResponse(service: .plone,
                                      account: a.account,
                                      token: ploneAuthToken.token)
                
        }
        //            .subscribe(onSuccess: { authToken in
        //                 print("🎫 Plone authToken: \(authToken.token)")
        //            }) { error in
//                 print("🚨 Login error is \(error)")
//        }
            

        
        return response
        
        
    }
    
    func sigOut() {}
}
