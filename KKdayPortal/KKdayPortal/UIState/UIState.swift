//
//  UIState.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/1.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

enum UIState<TValue: Equatable> {
    case normal(value: TValue)
    case success(value: TValue, message: String, duration: Double, completion: (() -> Bool)?)
    case error(value: TValue, message: String, duration: Double, completion: (() -> Bool)?)
}

extension UIState {
    
    var value: TValue {
        switch self {
        case .normal(value: let value):
            return value
        case .success(value: let value, message: _, duration: _, completion: _):
            return value
        case .error(value: let value, message: _, duration: _, completion: _):
            return value
        }
    }
    
    var message: String {
        switch self {
        case .normal(value: _):
            return ""
        case .success(value: _, message: let message, duration: _, completion: _):
            return message
        case .error(value: _, message: let message, duration: _, completion: _):
            return message
        }
    }
    
    var int: Int {
        switch self {
        case .normal(value: _):
            return 0
        case .success(value: _, message: _, duration: _, completion: _):
            return 1
        case .error(value: _, message: _, duration: _, completion: _):
            return 2
        }
    }
    
    var content: (value: TValue, message: String, duration: Double, completion: (() -> Bool)?) {
        
        switch self {
        case .normal(value: let value):
            return (value: value, message: "", duration: 0, completion: nil)
        case .success(value: let value, message: let message, duration: let duration, completion: let completion):
            return (value: value, message: message, duration: duration, completion: completion)
        case .error(value: let value, message: let message, duration: let duration, completion: let completion):
            return (value: value, message: message, duration: duration, completion: completion)
        }
    }
}

extension UIState: Equatable {
    static func ==(lhs: UIState<TValue>, rhs: UIState<TValue>) -> Bool {
        
        switch lhs {
        case .normal(value: let lhsValue):
            
            switch rhs {
            case .normal(value: let rhsValue):
                return lhsValue == rhsValue
            default:
                return false
            }
        case .success(value: let lhsValue, message: let lhsMessage, duration: let lhsDuration, completion: _):
            
            switch rhs {
            case .success(value: let rhsValue, message: let rhsMessage, duration: let rhsDuration, completion: _):
                return lhsValue == rhsValue && lhsMessage == rhsMessage && lhsDuration == rhsDuration
            default:
                return false
            }
        case .error(value: let lhsValue, message: let lhsMessage, duration: let lhsDuration, completion: _):
            
            switch rhs {
            case .error(value: let rhsValue, message: let rhsMessage, duration: let rhsDuration, completion: _):
                return lhsValue == rhsValue && lhsMessage == rhsMessage && lhsDuration == rhsDuration
            default:
                return false
            }
        }
    }
}
