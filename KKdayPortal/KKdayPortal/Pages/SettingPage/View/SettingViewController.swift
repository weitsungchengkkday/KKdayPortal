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
    lazy var languageButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Language Page", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    lazy var renewTokenButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("RenewToken", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    lazy var logoutButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Logout", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    lazy var testingButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Testing", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    private let viewModel = SettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setAction()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.title = "Setting"
        view.addSubview(languageButton)
        view.addSubview(renewTokenButton)
        view.addSubview(logoutButton)
        view.addSubview(testingButton)
        
        languageButton.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(145)
        }
        
        renewTokenButton.snp.makeConstraints { maker in
            maker.top.equalTo(languageButton.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(145)
        }
        
        logoutButton.snp.makeConstraints { maker in
            maker.top.equalTo(renewTokenButton.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(145)
        }
        
        testingButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.width.equalTo(145)
            maker.bottom.equalTo(self.view.snp.bottomMargin).offset(-80)
        }
        
    }
    
    // 🎬 set action
    private func setAction() {
        languageButton.addTarget(self, action: #selector(goLanguagePage), for: .touchUpInside)
        renewTokenButton.addTarget(self, action: #selector(renewToken), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        testingButton.addTarget(self, action: #selector(goTestingPage), for: .touchUpInside)
    }
    
    @objc private func goLanguagePage() {
        let presentViewController = LanguageSettingViewController(viewModel: LanguageViewModel())
        present(presentViewController, animated: true, completion: nil)
    }
    
    @objc private func renewToken() {
        viewModel.renewToken()
    }
    
    @objc private func logout() {
        viewModel.logout()
    }
    
    @objc private func goTestingPage() {
        let presentViewController = TestingViewController(viewModel: TestingViewModel())
        present(presentViewController, animated: true, completion: nil)
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        
    }

}
