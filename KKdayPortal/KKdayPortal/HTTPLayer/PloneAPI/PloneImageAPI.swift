//
//  PloneImageAPI.swift
//  KKdayPortal
//
//  Created by KKday on 2021/4/8.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import DolphinHTTP
import UIKit

final class PloneImageAPI {
    
    private let loader: HTTPLoader
    
    init(loader: HTTPLoader = URLSessionLoader()) {
        self.loader = loader
    }
    
    func getPloneImage(url: URL, completion: @escaping (Result<UIImage, HTTPError>) -> Void) {
        
        var r = HTTPRequest()
        r.host = url.host
        r.path = url.path

        let generalUser: GeneralUser? = StorageManager.shared.loadObject(for: .generalUser)
        
        guard let user = generalUser else {
            let error = HTTPError(code: .invalidRequest, request: r, response: nil, underlyingError: nil)
            completion(.failure(error))
            return
        }
        
        let token = user.token
       
        r.headers = [
            "Accept":"application/json",
            "Content-Type":"application/json",
            "Authorization": "Bearer" + " " + token
        ]
        
        r.method = .get
        
        loader.load(request: r) { result in
            
            switch result {
            case .success(let response):
                
                switch response.status {
                case .success:
                    
                    let error = HTTPError(code: .invalidResponse, request: r, response: nil, underlyingError: nil)
                    
                    if let body = response.body {
                        
                        if let image = UIImage(data: body) {
                            completion(.success(image))
                        } else {
                            completion(.failure(error))
                        }
                        
                    } else {
                        completion(.failure(error))
                    }
                    
                default:
                    print(response.status)
                    let error = HTTPError(code: .invalidResponse, request: r, response: response, underlyingError: nil)
                    completion(.failure(error))
                }
                
            case .failure(let error):
                print(error)
                let error = HTTPError(code: .invalidResponse, request: r, response: nil, underlyingError: error)
                completion(.failure(error))
            }
            
        }
    }
    
}

