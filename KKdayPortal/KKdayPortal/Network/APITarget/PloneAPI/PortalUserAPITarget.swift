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
        
        var baseURL: URL {
            return route
        }
        
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
        let route: URL
    }
    
    struct RenewToken: PortalUserAPITargetType {
        
        typealias ResponseType = PloneAuthToken
        
        var baseURL: URL {
            return route
        }
        
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
        let route: URL
        let token: String
        
        init(user: PloneUser?, route: URL) {
            self.user = user
            self.route = route
            self.token = user?.token ?? ""
        }
    }
    
    struct Logout: PortalUserAPITargetType {
        
        typealias ResponseType = PloneEmptyData
        
        var baseURL: URL {
            return route
        }
        
        var headers: [String: String]? {
            return ["Accept": "application/json",
                    "Authorization" : "Bearer" + " " + token
            ]
        }
        
        var path: String {
            return "/@logout"
        }
        
        var method: Method {
            return .post
        }
        
        var task: Task {
            return .requestParameters(parameters: [:], encoding: JSONEncoding.default)
        }
        
        let user: PloneUser?
        let route: URL
        let token: String
        
        init(user: PloneUser?, route: URL) {
            self.user = user
            self.route = route
            self.token = user?.token ?? ""
        }
    }
}
