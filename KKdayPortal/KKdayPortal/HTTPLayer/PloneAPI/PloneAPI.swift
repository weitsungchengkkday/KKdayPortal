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
    
    init(loader: HTTPLoader) {
        self.loader = loader
    }
    
    func signin(url: URL, account: String, password: String, completion: @escaping (Result<GeneralUser, DolphinHTTP.HTTPError>) -> Void) {
        var r = HTTPRequest()
        r.host = url.absoluteString
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
        
        let jsonData = try! JSONSerialization.data(withJSONObject: json)
        r.body = DataBody(jsonData)
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
                                let error = DolphinHTTP.HTTPError(code: .invalidResponse, request: r, response: response, underlyingError: nil)
                                completion(.failure(error))
                                return
                            }
                            
                            let user = GeneralUser(account: account, token: token)
                            completion(.success(user))
                            
                        } catch(let error){
                            
                            let error = DolphinHTTP.HTTPError(code: .invalidResponse, request: r, response: response, underlyingError: error)
                            completion(.failure(error))
                        }
                    }
                    
                default:
                    print(response.status)
                    let error =  DolphinHTTP.HTTPError(code: DolphinHTTP.HTTPError.Code.invalidResponse, request: r, response: nil, underlyingError: nil)
                    completion(.failure(error))
                }
                
                return
                
            case .failure(let error):
                let error =  DolphinHTTP.HTTPError(code: DolphinHTTP.HTTPError.Code.invalidResponse, request: r, response: nil, underlyingError: error)
                completion(.failure(error))
                
                return
            }
        }
        
    }
    
    func logout() {
        var r = HTTPRequest()
        r.path = "/@logout"
        r.method = .post
      
    }
    
    func getPloneItem(compeletion: (GeneralItem)->  Void) {
           
        
    }
}
