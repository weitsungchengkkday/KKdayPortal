//
//  APIManager.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/22.
//  Copyright © 2019 KKday. All rights reserved.
//

import Foundation
import Moya
import RxSwift

final public class APIManager {
    
    public static var `default` = APIManager()
    
    weak var httpErrorHandler: ErrorManageable?
    
    private init() {}
    
    // MoyaProvider Initailizator with MultiTarget type by Moya:
    private lazy var provider = MoyaProvider<MultiTarget>()
    
    // MARK: - RxSwfit
    /// Start a target request
    ///
    /// - Parameter request: Conform CodableResponseType, see more: `APIManagerProtocol.swift`
    /// - Returns: Return a Single Observerable object.
    public func request<Request: CodableResponseType>(_ request: Request) -> Single<Request.ResponseType> {
        
        let target = MultiTarget(request)
        print("🛎 RxSwift APIMangager request Start")
        var rxRequest = provider.rx.request(target)
            .map({ response in
                
                let statusCode = response.statusCode
                
                switch statusCode {
                // Information
                case 100...199:
                    return response
                // Success
                case 200...399:
                    return response
                // Client Error
                case 400...499:
                    switch statusCode {
                    case 401:
                        throw HTTPError.unauthorized
                    case 403:
                        throw HTTPError.forbidden
                    case 404:
                        throw HTTPError.notFound
                    default:
                        throw HTTPError.clientError
                    }
                // Server Error
                case 500...599:
                    switch statusCode {
                    case 500:
                        throw HTTPError.internalServerError
                    case 501:
                        throw HTTPError.notImplemented
                    default:
                        throw HTTPError.serverError
                    }
                    
                default:
                    throw HTTPError.otherError
                }
                
            })
            .catchError({ [weak self] error -> Single<Response> in
                self?.httpErrorHandler?.handle(error: error)
                
                return Single.error(error)
            })
            .filterSuccessfulStatusAndRedirectCodes() // only 200 ~ 399 are Success
            .map(Request.ResponseType.self)
        
        rxRequest = rxRequest.debug()
        
        return rxRequest
    }
}
