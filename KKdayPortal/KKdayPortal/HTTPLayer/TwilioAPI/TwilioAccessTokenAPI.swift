//
//  TwilioAccessTokenAPI.swift
//  KKdayPortal
//
//  Created by KKday on 2021/4/14.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import DolphinHTTP

final class TwilioAccessTokenAPI {
    
    private let loader: HTTPLoader
    
    init(loader: HTTPLoader) {
        self.loader = loader
    }
    
    func getAccessToken(url: URL, identity: String, completion: @escaping((Result<String, HTTPError>) -> Void)) {
        var r = HTTPRequest()
        r.method = .post
        r.host = url.host
        r.path = url.path
 
        let jsonString = """
        {
            "client_token": "The_shortest_answer_is_doing",
            "identity": "\(identity)"
        }
        """

        r.body = DataBody(jsonString.data(using: .utf8)!)
        
        r.headers = ["Content-Type": "application/json; charset=utf8"]
    
        loader.load(request: r) { result in
            
            switch result {
            case .success(let response):
                
                switch response.status {
                case .success, .create:
                    if let body = response.body, let token = String(data: body, encoding: .utf8) {
                        completion(Result.success(token))
                        
                        print("💎 Twilio Access Token is :\(token)")
                    
                    } else {
                        let error = HTTPError(code: .invalidResponse, request: r, response: response, underlyingError: nil)
                        completion(Result.failure(error))
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


