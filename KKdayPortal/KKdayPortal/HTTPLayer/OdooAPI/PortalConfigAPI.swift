//
//  AuthCodeAPI.swift
//  KKdayPortal
//
//  Created by KKday on 2021/4/9.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import DolphinHTTP

final class PortalConfigAPI {
    
    private let loader: HTTPLoader
    
    init(loader: HTTPLoader) {
        self.loader = loader
    }
    
    // Authorization only apply on KKUserPortalConfig
    private func authorizationFormatter(clientID: String) -> String {
        let auth = """
            KKday id="\(clientID)",ts="\(Date().timeIntervalSince1970)",user="oa-api+\(clientID)@kkday.com"
        """
      
        return auth
    }
    
    func loadKKUserPortalConfig(clientID: String, completion: @escaping ((Result<PortalConfig, HTTPError>) -> Void )) {
        var r = HTTPRequest()

        r.host = ConfigManager.shared.odooModel.host.replacingOccurrences(of: "https://", with: "")
       
        r.path = "/api/v1/kkportal-config"
        r.headers = [
            "KK-Track-SEQ": "0",
            "KK-Track-ID": "0",
            "Accept": "application/vnd.api+json",
            "Authorization": authorizationFormatter(clientID: clientID)
        ]
        
        loader.load(request: r) { result in
            switch result {
            case .success(let response):
                
                switch response.status {
                case .success:
                   
                    if let body = response.body {
                        do {
                            let portalConfig = try JSONDecoder().decode(PortalConfig.self, from: body)
                            completion(Result.success(portalConfig))

                        } catch(let error) {
                            let error = HTTPError(code: .invalidResponse, request: r, response: response, underlyingError: error)
                            completion(Result.failure(error))
                        }
                    }
                    
                default:
                    let error = HTTPError(code: .invalidResponse, request: r, response: response, underlyingError: nil)
                    completion(Result.failure(error))
                }
                
            case .failure(let error):
                let error = HTTPError(code: .invalidResponse, request: r, response: nil, underlyingError: error)
                completion(Result.failure(error))
            }
        }
        
    }
    
    func loadCustomUserPortalConfig(url: URL, completion: @escaping ((Result<PortalConfig, HTTPError>) -> Void )) {
        
        var r = HTTPRequest()
        r.host = url.host
        r.path = url.path
        
        loader.load(request: r) { result in
            switch result {
            case .success(let response):
                
                switch response.status {
                case .success:
                   
                    if let body = response.body {
                        do {
                            let portalConfig = try JSONDecoder().decode(PortalConfig.self, from: body)
                            completion(Result.success(portalConfig))

                        } catch(let error) {
                            let error = HTTPError(code: .invalidResponse, request: r, response: response, underlyingError: error)
                            completion(Result.failure(error))
                        }
                    }
                    
                default:
                    let error = HTTPError(code: .invalidResponse, request: r, response: response, underlyingError: nil)
                    completion(Result.failure(error))
                }
                
            case .failure(let error):
                let error = HTTPError(code: .invalidResponse, request: r, response: nil, underlyingError: error)
                completion(Result.failure(error))
            }
        }
        
    }
     
}


