//
//  PortalUserAPITarget.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/22.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Moya

enum PortalUser {
    
    struct Login: PortalUserAPITargetType {
        typealias ResponseType = PloneAuthToken
        
        var headers: [String: String]? {
            return ["Accept": "application/json",
                    "Content-Type": "application/json"
            ]
        }
        
        var path: String {
            return "/@login"
        }
        
        var method: Method {
            return .post
        }
        
        var task: Task {
            let params = [
                "login": account,
                "password": password
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
        
        let account: String
        let password: String
    }
    
    struct RenewToken: PortalUserAPITargetType {
        
        typealias ResponseType = PloneAuthToken
        
        var headers: [String: String]? {
            
            return [
                "Accept" : "application/json",
                "Authorization" : "Bearer" + " " + token
            ]
        }
        
        var path: String {
            return "@login-renew"
        }
        
        var method: Method {
            return .post
        }
        
        var task: Task {
            return .requestParameters(parameters: [:], encoding: JSONEncoding.default)
        }
        
        let user: PloneUser?
        let token: String
        
        init(user: PloneUser?) {
            self.user = user
            self.token = user?.token ?? ""
        }
    }
    
    // MARK: Plone  Invalidating a token (@logout) can not be called
    // Plone API Document: https://plonerestapi.readthedocs.io/en/latest/authentication.html
}
