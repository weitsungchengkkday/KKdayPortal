//
//  SigninInfoViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/11/12.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import DolphinHTTP

final class SigninInfoViewModel {
    
    func getKKUserPortalConfig(isSuccess: @escaping ((Bool) -> Void)) {
        
        let client = ConfigManager.shared.odooModel.client
        
        let api = PortalConfigAPI(loader: URLSessionLoader())
        
        api.loadKKUserPortalConfig(clientID: client) { result in
            
            switch result {
            case .success(let config):
                // Save 💾 Portal Cofig
                StorageManager.shared.saveObject(for: .portalConfig, value: config)
                isSuccess(true)
                
            case .failure(let error):
                print("❌ Error: \(error)")
                isSuccess(false)
            }
        }
    }
    
    func getCustomUserPortalConfig(url: URL, completion: @escaping ((Result<PortalConfig, HTTPError>) -> Void)) {
        
        let api = PortalConfigAPI(loader: URLSessionLoader())
        
        api.loadCustomUserPortalConfig(url: url) { result in
            switch result {
            case .success(let config):
                // Save 💾 Portal Cofig
                StorageManager.shared.saveObject(for: .portalConfig, value: config)
                completion(.success(config))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}



