//
//  NoInformationLabel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/13.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

final class NoInformationLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.numberOfLines = 0
        self.font = UIFont.systemFont(ofSize: 24)
        self.adjustsFontSizeToFitWidth = true

        self.text = "Folder's information has not been created"
        
        self.textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

