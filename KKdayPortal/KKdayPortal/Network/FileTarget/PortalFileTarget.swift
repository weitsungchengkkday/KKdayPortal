//
//  PortalFileTarget.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/1.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Moya

enum PortalFile {
    
    struct Unclassified: PortalFileTargetType {
        
        var baseURL: URL {
            return fileRoute
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
        
        var headers: [String : String]? {
            return [
                  "Accept" : "application/json",
                  "Authorization" : "Bearer" + " " + token
              ]
        }
        
        let fileRoute: URL
        let user: PloneUser?
        let token: String
        
        init(user: PloneUser?, fileRoute: URL) {
            self.user = user
            self.fileRoute = fileRoute
            self.token = user?.token ?? ""
        }
    }
}
