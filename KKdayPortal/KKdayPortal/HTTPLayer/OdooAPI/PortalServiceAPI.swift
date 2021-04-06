//
//  PortalApplicationsAPI.swift
//  KKdayPortal
//
//  Created by KKday on 2020/12/21.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import DolphinHTTP

final class PortalServiceAPI {
    
    lazy var loader: HTTPLoader = {
        let loader = URLSessionLoader()
        return loader
    }()
    
    init(loader: HTTPLoader) {
        self.loader = loader
    }
    
    func loadPortalService(completion: @escaping (Result<[PortalService],HTTPError>) -> Void) {
        var r = HTTPRequest()
        
        r.host = ConfigManager.shared.odooModel.host.replacingOccurrences(of: "https://", with: "")
    
        r.path = "/portal_service"
        
        print(r)
        
        loader.load(request: r) { result in
            switch result {
            case .success(let response):
                
                switch response.status {
                case .success:
                    if let body = response.body {
                        do {
                            let portalServices = try JSONDecoder().decode([PortalService].self, from: body)
                            completion(Result.success(portalServices))
                            
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


final class PortalServiceElementAPI {
    
    lazy var loader: HTTPLoader = {
        let loader = URLSessionLoader()
        return loader
    }()
    
    init(loader: HTTPLoader) {
        self.loader = loader
    }
    
    func loadPortalServiceElement(serviceID: Int, completion: @escaping (Result<[PortalServiceElement],HTTPError>) -> Void) {
        var r = HTTPRequest()
    
        r.host = ConfigManager.shared.odooModel.host.replacingOccurrences(of: "https://", with: "")
   
        r.path = "/portal_service" + "/\(serviceID)" +  "/portal_service_element"
        
        loader.load(request: r) { result in
            switch result {
            case .success(let response):
                
                switch response.status {
                case .success:
                    if let body = response.body {
                        do {
                            let portalServiceElements = try JSONDecoder().decode([PortalServiceElement].self, from: body)
                            completion(Result.success(portalServiceElements))
                            
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


