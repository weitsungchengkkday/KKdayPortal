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

final class SettingViewController: UIViewController, Localizable, NetStatusProtocal {
    
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
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    lazy var aboutButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    lazy var contactMeButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    lazy var logoutButton: UIButton = {
        let btn = UIButton()
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
        lbl.text = ConfigManager.shared.serverEnv.identity + " " + "Version" + " " + Utilities.getCurrentVersion()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return lbl
    }()
    
    var observerLanguageChangedNotification: NSObjectProtocol?
    
    func refreshLanguage(_ nofification: Notification) {
        localizedText()
    }
    
    var observerNetStatusChangedNotification: NSObjectProtocol?
    
    func noticeNetStatusChanged(_ nofification: Notification) {
        checkNetStatusSnackBar()
    }
    
    private let viewModel = SettingViewModel()
    
    private let testingModeTapRequired: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setAction()
        registerLanguageManager()
        registerNetStatusManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkNetStatusSnackBar()
    }
    
    deinit {
        unregisterNetStatusManager()
        unregisterLanguageManager()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        localizedText()
        
        view.addSubview(settingStackView)
        settingStackView.addArrangedSubview(languageButton)
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
    
    // 🧾 localization
    private func localizedText() {
        self.title = "setting_title".localize("設定", defaultValue: "Setting")
        languageButton.setTitle("setting_button_language".localize("語言設定", defaultValue: "Language Setting"), for: .normal)
        aboutButton.setTitle("setting_button_about".localize("關於 KKPlone", defaultValue: "About KKPlone"), for: .normal)
        contactMeButton
            .setTitle("setting_button_contact".localize("聯絡我", defaultValue: "Contact Me"), for: .normal)
        logoutButton.setTitle("setting_button_logout".localize("登出", defaultValue: "Logout"), for: .normal)
    }
    
    // 🎬 set action
    private func setAction() {
        languageButton.addTarget(self, action: #selector(goLanguagePage), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        aboutButton.addTarget(self, action: #selector(goAboutPage), for: .touchUpInside)
        contactMeButton.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)

    }
    
    @objc private func goLanguagePage() {
        let presentViewController = LanguageSettingViewController(viewModel: LanguageViewModel())
        present(presentViewController, animated: true, completion: nil)
    }
    
    @objc private func logout() {
        
        let alertController =  UIAlertController(title: "general_warning".localize("警告", defaultValue: "Warning"), message: "general_alert_logout_message".localize("登出將會清除您在 KKPortal 上的所有已存的個人資訊", defaultValue: "Logout will clear all personal information in KKPortal"), preferredStyle: .alert)
        
        let confirmAlertAction = UIAlertAction(title: "general_confrim".localize("確認", defaultValue: "Confirm"), style: .default) { [weak self] _ in
            self?.viewModel.logout()
        }
        
        let cancelAlertAction = UIAlertAction(title: "general_cancel".localize("取消", defaultValue: "Cancel"), style: .cancel, handler: nil)
        
        alertController.addAction(confirmAlertAction)
        alertController.addAction(cancelAlertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func goAboutPage() {
        
        let presentViewController = AboutViewController()
        present(presentViewController, animated: true, completion: nil)
    }
    
    @objc private func sendEmail() {
        
        if MFMailComposeViewController.canSendMail() {
            let emailVC = MFMailComposeViewController()
            emailVC.mailComposeDelegate = self
            emailVC.setSubject("general_email_subject".localize("KKPortal 建議", defaultValue: "KKPortal Suggestion"))
            emailVC.setToRecipients(["william.cheng@kkday.com"])
            
            let bodyMessage = "general_email_message_body".localize("我的意見是", defaultValue: "My opinion")
            emailVC.setMessageBody("<h3>\(bodyMessage) :</h3><p>\n</p>", isHTML: true)
            present(emailVC, animated: true, completion: nil)
            
        } else {
            
            let alertViewController = UIAlertController(title: "general_warning".localize("警告", defaultValue: "Warning"), message: "general_alert_email_message".localize("請開啟您的 email 服務", defaultValue: "Please open your email service"), preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "general_ok".localize("好", defaultValue: "OK"), style: .default, handler: nil)
            alertViewController.addAction(alertAction)
            present(alertViewController, animated: true, completion: nil)
        }
    }
    
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
