//
//  TwilioServiceManager.swift
//  KKdayPortal
//
//  Created by KKday on 2020/12/30.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import UIKit

final class TwilioServiceManager {
    
    static let shared = TwilioServiceManager()
    
    var twiVC: TwilioServiceViewController = TwilioServiceViewController()
    
    private init() {
        
    }
    
}
