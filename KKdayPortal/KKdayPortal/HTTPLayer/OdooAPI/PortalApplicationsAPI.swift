//
//  PortalApplicationsAPI.swift
//  KKdayPortal
//
//  Created by KKday on 2020/12/21.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import DolphinHTTP

final class PortalApplicationsAPI {
    
    lazy var loader: HTTPLoader = {
        let loader = URLSessionLoader()
        return loader
    }()
    
    init(loader: HTTPLoader) {
        self.loader = loader
    }
    
    func loadApplicationServers() {
        var r = HTTPRequest()
    
        r.host = ConfigManager.shared.odooModel.host.replacingOccurrences(of: "https://", with: "")
        
        r.path = "/portal_applications"
        
        loader.load(request: r) { result in
            switch result {
            case .success(let response):
          
                switch response.status {
                case .success:
                    if let body = response.body {
                        do {
                        
                            let applicationSevers = try JSONDecoder().decode([ApplicationSever].self, from: body)
 
                            for server in applicationSevers {
                                switch server.host {
                                case "BPM":
                                    StorageManager.shared.saveObject(for: .bpmServerType, value: server)
                                default:
                                    return
                                }
                            }
                            
                        } catch(let error) {
                            let error = HTTPError(code: .invalidResponse, request: r, response: response, underlyingError: error)
                            print("❌ Save BPM decode error: \(error)")
                        }
                    }

                default:
                    let error = HTTPError(code: .invalidResponse, request: r, response: response, underlyingError: nil)
                    print("❌ Save BPM HTTP error: \(error)")
                }

            case .failure(let error):
                let error = HTTPError(code: .invalidResponse, request: r, response: nil, underlyingError: error)
                print("❌ Save BPM error: \(error)")
            }
        }
    }

}



