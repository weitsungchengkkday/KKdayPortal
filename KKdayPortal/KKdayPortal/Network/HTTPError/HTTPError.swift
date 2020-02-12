//
//  HTTPError.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/10.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

enum HTTPError: Error {
    // 400 series
    case unauthorized  // 401
    case forbidden // 403
    case notFound // 404
    case clientError
    // 500 series
    case internalServerError // 500
    case notImplemented // 501
    case serverError
    // others
    case otherError
}

extension HTTPError {
    
    var message: String {
        
        switch self {
        case .unauthorized, .forbidden, .notFound, .clientError:
            return "Authorization Error, \n Please Login Again"
        case .internalServerError, .notImplemented, .serverError:
            return "Server Exception"
        case .otherError:
            return "System Exception"
        }
    }
}
