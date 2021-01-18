//
//  OpenTwilioServiceManager.swift
//  KKdayPortal-Open
//
//  Created by KKday on 2021/1/18.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import UIKit

final class OpenTwilioServiceManager {
    
    static let shared = OpenTwilioServiceManager()
    
    var twiVC: OpenTwilioServiceViewController = OpenTwilioServiceViewController()
    
    private init() {
        
    }
    
}
