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
        btn.setTitle("Language Setting (preparing...)", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.isEnabled = false
        return btn
    }()
    
    lazy var renewTokenButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("RenewToken", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        btn.layer.cornerRadius = 8
        btn.isHidden = true
        return btn
    }()
    
    lazy var logoutButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Logout", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    lazy var logoWithTextImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "icKkdayLogoWithText")
        imv.isUserInteractionEnabled = true
        return imv
    }()
    
    lazy var versionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.text = "Version" + " " + Utilities.getCurrentVersion()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return lbl
    }()
    
    private let viewModel = SettingViewModel()
    private let testingModeTapRequired: Int = 10
    
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
        view.addSubview(logoWithTextImageView)
        view.addSubview(versionLabel)
        
        languageButton.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            maker.centerX.equalToSuperview()
            maker.height.equalTo(60)
            maker.width.equalToSuperview().offset(-60)
        }
        
        renewTokenButton.snp.makeConstraints { maker in
            maker.top.equalTo(languageButton.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
            maker.height.equalTo(60)
            maker.width.equalToSuperview().offset(-80)
        }
        
        logoutButton.snp.makeConstraints { maker in
            maker.top.equalTo(renewTokenButton.snp.bottom).offset(50)
            maker.centerX.equalToSuperview()
            maker.height.equalTo(60)
            maker.width.equalToSuperview().offset(-200)
        }
        
        logoWithTextImageView.snp.makeConstraints { maker in
            maker.width.equalTo(180)
            maker.height.equalTo(77.4)
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(view.snp.bottomMargin).offset(-44)
        }
        
        versionLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(logoWithTextImageView.snp.bottom).offset(7)
        }
    }
    
    // 🎬 set action
    private func setAction() {
        languageButton.addTarget(self, action: #selector(goLanguagePage), for: .touchUpInside)
        renewTokenButton.addTarget(self, action: #selector(renewToken), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(goTestingPage))
        recognizer.numberOfTapsRequired = testingModeTapRequired
        logoWithTextImageView.addGestureRecognizer(recognizer)
        
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
