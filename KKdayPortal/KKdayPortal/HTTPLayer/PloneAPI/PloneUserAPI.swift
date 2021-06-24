//
//  PloneAPI.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/11/12.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import DolphinHTTP

final class PloneUserAPI {
    
    private let loader: HTTPLoader
    
    init(loader: HTTPLoader) {
        self.loader = loader
    }
    
    func signin(url: URL, account: String, password: String, completion: @escaping (Result<GeneralUser, HTTPError>) -> Void) {
        var r = HTTPRequest()
        r.host = url.host
        r.path = "/Plone/@login"
        
        r.headers = [
            "Accept":"application/json",
            "Content-Type":"application/json"
        ]
        
        let json =
        [
            "login": "\(account)",
            "password": "\(password)"
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json)
            r.body = DataBody(jsonData)
            
        } catch {
            let error = HTTPError(code: .invalidRequest, request: r, response: nil, underlyingError: error)
            completion(.failure(error))
        }
        
        r.method = .post
      
        loader.load(request: r) { result in
            
            switch result {
            case .success(let response):
                
                switch response.status {
                case .success:
                    if let body = response.body {
                        
                        do {
                            let jsonData = try JSONSerialization.jsonObject(with: body, options: [])
                            
                            guard let data = jsonData as? [String : String],
                                  let token = data["token"] else {
                                let error = HTTPError(code: .invalidResponse, request: r, response: response, underlyingError: nil)
                                completion(.failure(error))
                                return
                            }
                            
                            let user = GeneralUser(account: account, token: token)
                            completion(.success(user))
                            
                        } catch(let error){
                            
                            let error = HTTPError(code: .invalidResponse, request: r, response: response, underlyingError: error)
                            completion(.failure(error))
                        }
                    }
                    
                default:
                    let error = HTTPError(code: HTTPError.Code.invalidResponse, request: r, response: nil, underlyingError: nil)
                    completion(.failure(error))
                }
                
                return
                
            case .failure(let error):
                let error = HTTPError(code: HTTPError.Code.invalidResponse, request: r, response: nil, underlyingError: error)
                completion(.failure(error))
                
                return
            }
        }
        
    }
    
    // Plone Logout API Not Work
    // Just Clear Plone related Data in APP
    func signout(account: String, token: String, completion: @escaping (Result<GeneralUser, HTTPError>) -> Void) {
        
        let user: GeneralUser? = StorageManager.shared.loadObject(for: .generalUser)
        let r = HTTPRequest()
        
        guard let genernalUser = user else {
            let error = HTTPError(code: .invalidResponse, request: r, response: nil, underlyingError: nil)
            completion(.failure(error))
            return
        }

        completion(.success(genernalUser))
    }
    
}


