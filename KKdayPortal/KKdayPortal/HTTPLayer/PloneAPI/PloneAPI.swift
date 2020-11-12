//
//  PloneAPI.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/11/12.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import DolphinHTTP

final class PloneAPI {
    
    private let loader: HTTPLoader
    
    private var servEnvironment: ServerEnvironment {
            return ServerEnvironment.PloneSit
    }
    
    init(loader: HTTPLoader) {
        self.loader = loader
    }
    
    func login() {
        var r = HTTPRequest()
        r.path = "/@login"
        r.method = .post
        r.serverEnvironment = ServerEnvironment.PloneSit
    }
    
    func logout() {
        var r = HTTPRequest()
        r.path = "/@logout"
        r.method = .post
        r.serverEnvironment = ServerEnvironment.PloneSit
    }
    
    func getPloneItem(compeletion: (GeneralItem)->  Void) {
           
        
    }
}
