//
//  PloneItemsAPI.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/11/13.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import DolphinHTTP

final class PloneItemsAPI {
    
    lazy var loader: HTTPLoader = {
        let loader = URLSessionLoader()
        return loader
    }()
    
    
    func getPloneItem<T> (user: PloneUser?, route: URL, ploneType: T.Type, compeletion: @escaping (Result<PloneItem, HTTPError>) ->  Void) where T: PloneItem {
        
        var r = HTTPRequest()
        r.host = route.host
        r.path = route.path
        
        
        r.method = .get
        
        let generalUser: GeneralUser? = StorageManager.shared.loadObject(for: .generalUser)
        
        guard let user = generalUser else {
            let error = HTTPError(code: .invalidRequest, request: r, response: nil, underlyingError: nil)
            compeletion(.failure(error))
            return
        }
        
        let token = user.token
        
        r.headers = [
            "Accept" : "application/json",
            "Content-Type" : "application/json",
            "Authorization" : "Bearer" + " " + token
        ]
        
        loader.load(request: r) { result in
            
            switch result {
            case .success(let response):
                
                switch response.status {
                case .success:
                    if let body = response.body {
                        do {
                            let ploneItem: T = try JSONDecoder().decode(T.self, from: body)
                            compeletion(.success(ploneItem))
                            
                        } catch(let error) {
                            let error = HTTPError(code: .invalidResponse, request: r, response: response, underlyingError: error)
                            compeletion(.failure(error))
                        }
                    }
                    
                default:
                    print(response.status)
                    let error = HTTPError(code: .invalidResponse, request: r, response: response, underlyingError: nil)
                    compeletion(.failure(error))
                }
                
            case .failure(let error):
                print(error)
                let error = HTTPError(code: .invalidResponse, request: r, response: nil, underlyingError: error)
                compeletion(.failure(error))
            }
            
        }
        
    }
    
}
