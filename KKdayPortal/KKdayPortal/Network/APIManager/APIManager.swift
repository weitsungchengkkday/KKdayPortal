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
        print("RxSwift APIMangager request start")
        
        var rxRequest = provider.rx.request(target)
            .filterSuccessfulStatusAndRedirectCodes()
            .map(Request.ResponseType.self)
        
        rxRequest = rxRequest.debug()
        
        return rxRequest
    }
}
