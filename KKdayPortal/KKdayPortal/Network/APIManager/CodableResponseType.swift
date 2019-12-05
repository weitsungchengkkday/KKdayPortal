//
//  CodableResponseType.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/22
//  Copyright © 2019 KKday. All rights reserved.
//

import Moya

public protocol CodableResponseType: TargetType {
    
    associatedtype ResponseType: Codable
}


