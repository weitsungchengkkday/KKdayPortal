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
        
        typealias ResponseType = KKPloneToken
        
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
        
       private let account: String
       private let password: String
    }
    
    struct Login_renew: PortalUserAPITargetType {
        
        typealias ResponseType = KKPloneToken
        
        var headers: [String: String]? {
            let token: String = StorageManager.shared.load(for: .authToken) ?? ""
            
            return [
                "Accept" : "application/json",
                "Content-Type" : "Bearer" + " " + token
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
    }
    
}
