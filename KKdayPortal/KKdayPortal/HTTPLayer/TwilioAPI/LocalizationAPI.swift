//
//  LocalizationAPI.swift
//  KKdayPortal
//
//  Created by KKday on 2021/6/21.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import DolphinHTTP

final class LocalizationAPI {
    
    private let loader: HTTPLoader
    
    init(loader: HTTPLoader) {
        self.loader = loader
    }
    
    func getLocalizationFile(url: URL, language: String, completion: @escaping((Result<Data, HTTPError>) -> Void)) {
        
        var r = HTTPRequest()
        r.method = .get
        r.host = url.host
        r.path = "/assets/\(language)" + "_" + "localization" + ".strings"
    
        loader.load(request: r) { result in
            switch result {
            case .success(let response):
                switch response.status {
                case .success, .create:
                    if let body = response.body {
                        completion(Result.success(body))
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
