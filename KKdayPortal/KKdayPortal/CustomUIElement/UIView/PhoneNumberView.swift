//
//  PhoneNumberView.swift
//  KKdayPortal
//
//  Created by KKday on 2020/11/24.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit

final class PhoneNumberView: UIView {
    
    private let numBtn = UIButton()
    private let imageView = UIImageView()
    private var image: UIImage
    
    var addNumHandler: () -> Void = {}
    
    required init(image: UIImage) {
        self.image = image
        super.init(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        numBtn.imageView?.contentMode = .scaleToFill
        imageView.image = image
        self.addSubview(imageView)
        self.addSubview(numBtn)
        
        self.imageView.snp.makeConstraints { maker in
            maker.top.leading.trailing.bottom.equalToSuperview()
        }
        
        self.numBtn.snp.makeConstraints { maker in
            maker.top.leading.trailing.bottom.equalToSuperview()
        }
        
        numBtn.addTarget(self, action: #selector(addNumber), for: .touchUpInside)
    }

    @objc func addNumber() {
        print("SSS")
        addNumHandler()
    }

}
