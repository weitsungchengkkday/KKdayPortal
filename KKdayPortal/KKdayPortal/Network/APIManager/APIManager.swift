//
//  APIManager.swift
//  KKdayPortal
//
//  Created by Tank Lin on 2019/4/12.
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
        #if DEBUG
        rxRequest = rxRequest.debug()
        #endif
        return rxRequest
    }
}
