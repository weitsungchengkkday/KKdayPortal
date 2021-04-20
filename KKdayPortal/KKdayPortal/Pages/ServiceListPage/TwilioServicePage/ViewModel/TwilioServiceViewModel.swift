//
//  TwilioServiceViewModel.swift
//  KKdayPortal
//
//  Created by KKday on 2021/4/14.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import DolphinHTTP

final class TwilioServiceViewModel {
    
    func loadTwilioAccessToken(url: URL, identity: String, completion: @escaping ((Result<String, HTTPError>) -> Void)) {
        LoadingManager.shared.setState(state: .normal(value: true))
        
        let api = TwilioAccessTokenAPI(loader: URLSessionLoader())
        
        api.getAccessToken(url: url, identity: identity) { result in
            completion(result)
        }
    }
}
