//
//  PortalItemAPITarget.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/26.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Moya

enum PortalItem {
    
    struct Item<T: PloneItem>: PortalItemAPITargetType {
        
        typealias ResponseType = T
        
        var baseURL: URL {
            return route
        }
        
        var path: String {
            return ""
        }
        
        var method: Method {
            return .get
        }
        
        var task: Task {
            return .requestPlain
        }
        
        var headers: [String: String]? {
            
            return [
                "Accept" : "application/json",
                "Authorization" : "Bearer" + " " + token
            ]
        }
        
        let route: URL
        let user: PloneUser?
        let token: String
     
        init(user: PloneUser?, route: URL) {
            self.route = route
            self.user = user
            self.token = user?.token ?? ""
        }
        
    }
    
    
   
}
