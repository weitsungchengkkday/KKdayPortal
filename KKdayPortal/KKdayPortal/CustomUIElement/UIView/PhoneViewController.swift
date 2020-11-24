//
//  PhoneViewController.swift
//  KKdayPortal
//
//  Created by KKday on 2020/11/24.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit

final class PhoneViewController: UIViewController {
    
    let phoneView = PhoneView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        self.view.addSubview(phoneView)
        
        phoneView.snp.makeConstraints { maker in
            maker.height.width.equalTo(100)
            maker.centerX.centerY.equalToSuperview()
        }
        
        phoneView.sendNumberHandler = { num in
            print(num)
        }
    }
    
}
