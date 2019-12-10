//
//  SettingViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/21.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit

final class SettingViewController: UIViewController {
    
    // 🏞 UI element
    lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Login Page", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setAction()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        self.title = "Setting"
        view.backgroundColor = UIColor.white
        view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(120)
        }
    }
    
    // 🎬 set action
    private func setAction() {
        loginButton.addTarget(self, action: #selector(goLoginPage), for: .touchUpInside)
    }
    
    @objc private func goLoginPage() {
        let presentViewController = LoginViewController(viewModel: LoginViewModel())
        present(presentViewController, animated: true, completion: nil)
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        
    }

}
