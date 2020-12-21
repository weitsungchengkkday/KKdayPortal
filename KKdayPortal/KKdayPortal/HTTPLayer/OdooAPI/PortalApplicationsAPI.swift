//
//  PortalApplicationsAPI.swift
//  KKdayPortal
//
//  Created by KKday on 2020/12/21.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import DolphinHTTP

// https://c585a74d7843.ngrok.io/portal_applications

final class PortalApplicationsAPI {
    
    lazy var loader: HTTPLoader = {
        let loader = URLSessionLoader()
        return loader
    }()
    
    init(loader: HTTPLoader) {
        self.loader = loader
    }
    
    func loadApplicationServers(completion: @escaping (Result<[ApplicationSever], HTTPError>) -> Void) {
        var r = HTTPRequest()
        r.host = "c585a74d7843.ngrok.io"
        r.path = "/portal_applications"
        
        loader.load(request: r) { result in
            switch result {
            case .success(let response):
          
                switch response.status {
                case .success:
                    if let body = response.body {
                        do {
                        
                        // 1
//                            if let jsonString = try JSONSerialization.jsonObject(with: body, options: []) as? [[String: Any]] {
//
//                                if let fileAdministrator = FileAdministrator(path: "portal"), fileAdministrator.writeTextFile(withName: "application_servers.json", fileContent: String(describing: jsonString), canOverwrite: false)  {
////
//                                      print("✏️ Save Data Success")
//                                }
//                            }
                               
                       // 2
                            let applicationSevers = try JSONDecoder().decode([ApplicationSever].self, from: body)
    
                            completion(.success(applicationSevers))

                        } catch(let error) {
                            let error = HTTPError(code: .invalidResponse, request: r, response: response, underlyingError: error)
                            completion(.failure(error))
                        }
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


struct ApplicationSever {
    let id: Int
    let name: String
    let local_server_url: String
    let stage_server_url: String
    let production_server_url: String
}

extension ApplicationSever: Decodable {
    
}
