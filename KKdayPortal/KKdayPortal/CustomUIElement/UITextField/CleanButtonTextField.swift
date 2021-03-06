//
//  CleanButtonTextField.swift
//  SCM-iOS APP
//
//  Created by wei-tsung-cheng on 2017/12/21.
//  Copyright © 2017年 KKday. All rights reserved.
//

import UIKit

class CleanButtonTextField: UITextField {

    private let cleanButton: UIButton = UIButton()
    private let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 14))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        cleanButton.setImage(#imageLiteral(resourceName: "ic-clear-white"), for: .normal)
        cleanButton.imageView?.contentMode = .scaleToFill
        cleanButton.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        cleanButton.addTarget(self, action: #selector(handler(sender:)), for: .touchUpInside)
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 18, height: 14)
        view.addSubview(cleanButton)
                                 
        rightView = view
        rightViewMode = .whileEditing
        leftView = paddingView
        leftViewMode = .always
        
        autocapitalizationType = .none
        autocorrectionType = .no
    }

    @objc func handler(sender: UITextField) {
        self.text = ""
        self.sendActions(for: .editingChanged)
    }
   
}
