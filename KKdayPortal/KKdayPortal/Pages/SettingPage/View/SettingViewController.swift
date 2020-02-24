//
//  SettingViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/21.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit
import MessageUI

final class SettingViewController: UIViewController {
    
    // 🏞 UI element
    
    lazy var settingStackView: UIStackView = {
        let stv: UIStackView = UIStackView()
        stv.axis = .vertical
        stv.alignment = .center
        stv.distribution = .fill
        stv.spacing = 50
        return stv
    }()
    
    lazy var languageButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Language Setting (preparing...)", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.isHidden = true
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
    
    lazy var aboutButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("About KKPlone", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    lazy var contactMeButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Contact Me", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    lazy var logoutButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Logout", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    lazy var logoWithTextImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "icApplicationItem")
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
    let testingModeIsOpen: Bool = true
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
        
        view.addSubview(settingStackView)
        settingStackView.addArrangedSubview(languageButton)
        settingStackView.addArrangedSubview(renewTokenButton)
        settingStackView.addArrangedSubview(aboutButton)
        settingStackView.addArrangedSubview(contactMeButton)
        settingStackView.addArrangedSubview(logoutButton)
        
        view.addSubview(logoWithTextImageView)
        view.addSubview(versionLabel)
        
        settingStackView.snp.makeConstraints { maker in
            maker.width.equalToSuperview()
            maker.centerX.centerY.equalToSuperview()
        }
        
        languageButton.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.width.equalToSuperview().offset(-60)
        }
        
        renewTokenButton.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.width.equalToSuperview().offset(-60)
        }
        
        aboutButton.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.width.equalToSuperview().offset(-60)
        }
        
        contactMeButton.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.width.equalToSuperview().offset(-60)
        }
        
        logoutButton.snp.makeConstraints { maker in
            maker.height.equalTo(44)
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
        aboutButton.addTarget(self, action: #selector(goAboutPage), for: .touchUpInside)
        contactMeButton.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
        
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
        let alertController =  UIAlertController(title: "Warning", message: "Logout will clear all personal information", preferredStyle: .alert)
        
        let confirmAlertAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] _ in
            self?.viewModel.logout()
        }
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAlertAction)
        alertController.addAction(cancelAlertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func goTestingPage() {
        if testingModeIsOpen {
            let presentViewController = TestingViewController(viewModel: TestingViewModel())
            present(presentViewController, animated: true, completion: nil)
        }
    }
    
    @objc private func goAboutPage() {
        let presentViewController = AboutViewController()
        present(presentViewController, animated: true, completion: nil)
    }
    
    @objc private func sendEmail() {
        
        if MFMailComposeViewController.canSendMail() {
            let emailVC = MFMailComposeViewController()
            emailVC.mailComposeDelegate = self
            emailVC.setSubject("KKPortal Suggestion")
            emailVC.setToRecipients(["william.cheng@kkday.com"])
            emailVC.setMessageBody("<h3>My opinion is:</h3><p>\n</p>", isHTML: true)
            present(emailVC, animated: true, completion: nil)
            
        } else {
            let alertViewController = UIAlertController(title: "Warning", message: "Please open your email service", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertViewController.addAction(alertAction)
            present(alertViewController, animated: true, completion: nil)
        }
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        
    }
    
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
