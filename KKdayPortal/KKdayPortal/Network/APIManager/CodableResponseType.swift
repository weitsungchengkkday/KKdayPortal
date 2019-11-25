//
//  CodableResponseType.swift
//  KKdayPortal
//
//  Created by Tank Lin on 2019/4/15.
//  Copyright © 2019 KKday. All rights reserved.
//

import Moya

public protocol CodableResponseType: TargetType {
    associatedtype ResponseType: Codable
}
