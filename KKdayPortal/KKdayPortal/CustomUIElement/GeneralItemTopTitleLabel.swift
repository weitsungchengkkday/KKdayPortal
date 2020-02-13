//
//  GeneralItemTopTitleLabel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/13.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

class GeneralItemTopTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.numberOfLines = 0
        self.font = UIFont.systemFont(ofSize: 24)
        self.adjustsFontSizeToFitWidth = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
