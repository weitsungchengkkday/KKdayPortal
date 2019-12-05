//
//  FileManager.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/1.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import Moya
import RxSwift

final public class FileManager {
    
    public static var `default` = FileManager()
    private init() {}
    
    private lazy var provider = MoyaProvider<MultiTarget>()
    
    public func downloadFile<Request: FileResponseType>(_ request: Request) -> Single<Data.Type> {
        
        let target = MultiTarget(request)
        let rxRequest = provider.rx.request(target)
            .filterSuccessfulStatusAndRedirectCodes()
            .map { _ in Data.self }
        
        return rxRequest
    }
}
