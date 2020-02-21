//
//  TogglePasswordTextField.swift
//  SCM-iOS APP
//
//  Created by wei-tsung-cheng on 2017/12/21.
//  Copyright © 2017年 KKday. All rights reserved.
//

import UIKit

class TogglePasswordTextField: UITextField {
    private let togglePasswordButton: UIButton = UIButton()

    private let canSeeImage: UIImage = #imageLiteral(resourceName: "ic-input-eye-visible-white")
    private let canNotSeeImage: UIImage = #imageLiteral(resourceName: "ic-input-eye-invisible-white")
    private var isSee: Bool = false {
        didSet {
            let image: UIImage = isSee ? canSeeImage : canNotSeeImage
            togglePasswordButton.setImage(image, for: .normal)

            self.isSecureTextEntry = !isSee
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }

    private func setUp() {
        isSee = false

        togglePasswordButton.imageView?.contentMode = .scaleAspectFit
        togglePasswordButton.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        togglePasswordButton.addTarget(self, action: #selector(togglePasswordHandler(sender:)), for: .touchUpInside)
        rightView = togglePasswordButton
        rightViewMode = .whileEditing
    }

    @objc func togglePasswordHandler(sender: UIButton) {
        isSee = !isSee
        self.becomeFirstResponder()
    }
}
