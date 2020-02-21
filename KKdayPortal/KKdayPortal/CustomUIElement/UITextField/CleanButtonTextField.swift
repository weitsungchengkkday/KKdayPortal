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
        cleanButton.imageView?.contentMode = .scaleAspectFit
        cleanButton.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        cleanButton.addTarget(self, action: #selector(handler(sender:)), for: .touchUpInside)

        rightView = cleanButton
        rightViewMode = .whileEditing
    }

    @objc func handler(sender: UITextField) {
        self.text = ""
        self.sendActions(for: .editingChanged)
    }
}
