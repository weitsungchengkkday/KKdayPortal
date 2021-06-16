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
    
    func loadKKPortalTwilioConfig(url: URL, completion: @escaping ((Result<Data, HTTPError>) -> Void)) {
        LoadingManager.shared.setState(state: .normal(value: true))
        
        let api = KKPortalTwilioConfigAPI(loader: URLSessionLoader())
        
        api.getKKPortalTwilioConfig(url: url) { result in
            DispatchQueue.main.async {
                LoadingManager.shared.setState(state: .normal(value: false))
                completion(result)
            }
        }
    }
    
    func loadTwilioAccessToken(url: URL, identity: String, completion: @escaping ((Result<String, HTTPError>) -> Void)) {
        
        let api = TwilioAccessTokenAPI(loader: URLSessionLoader())
        
        api.getAccessToken(url: url, identity: identity) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
