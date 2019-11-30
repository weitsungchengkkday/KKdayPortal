//
//  RXViewModelType.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/30.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

protocol RXViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}
