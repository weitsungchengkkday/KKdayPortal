//
//  StartUseViewController.swift
//  KKdayPortal
//
//  Created by KKday on 2021/4/21.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

final class StartUseViewController: UIViewController, Localizable {
    
    // 🏞 UI element
    
    lazy var startUseStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.distribution = .fill
        stv.alignment = .center
        stv.spacing = 60
        return stv
    }()
    
    lazy var startUseTextView: UITextView = {
        let txv = UITextView()
        txv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        txv.layer.cornerRadius = 20
        txv.font = UIFont.boldSystemFont(ofSize: 16)
        txv.textColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        txv.isEditable = false

        return txv
    }()
    
    lazy var comfirmButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    var observerLanguageChangedNotification: NSObjectProtocol?
    
    func refreshLanguage(_ nofification: Notification) {
        localizedText()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setAction()
        registerLanguageManager()
    }
    
    deinit {
        unregisterLanguageManager()
    }
    
    private func setupUI() {
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        localizedText()
        
        self.view.addSubview(startUseStackView)
        startUseStackView.addArrangedSubview(startUseTextView)
        startUseStackView
            .addArrangedSubview(comfirmButton)
        startUseStackView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(60)
            maker.leading.equalToSuperview().offset(30)
            maker.trailing.equalToSuperview().offset(-30)
            maker.bottom.equalToSuperview().offset(-60)
        }
        
        startUseTextView.snp.makeConstraints { maker in
            maker.width.equalTo(self.view.snp.width).offset(-50)
        }
        
        comfirmButton.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.width.equalTo(self.view.snp.width).offset(-100)
        }
    }
    
    // 🧾 localization
    private func localizedText() {
        
        comfirmButton.setTitle("general_ok".localize("好", defaultValue: "OK"), for: .normal)
        
        let startUseTitle = "start_use_textview_title".localize("開始使用", defaultValue: "Start to use")
        let startUseContentOne = "start_use_textview_content_one".localize("KKporal是由配置數據啟動時，用戶必須在為了通過HTTP [GET]方法來獲取配置數據提供鏈路。響應數據必須可以是UTF-8解碼為字符串如下：", defaultValue: "KKporal is start up by config data, user must provide link in order to get config data by HTTP [GET] method. Response data must can be utf-8 decode to String as below:")
        let startUseContentTwo = "start_use_textview_content_two".localize("＃{{...}}的手段，您需要提供自己的信息", defaultValue: "# {{ .... }}  means, you need to provide your own Info")
        
        let startUseContentThree = "start_use_textview_content_three".localize("""
            筆記
            0. KKPortal限制用戶必須是Plone的用戶，如果您還沒有Plone的網站，請注意應用。

            1. KKPortal Plone的使用授權登錄，如果你的Plone網站是不公開的，除了提供配置鏈接，您還需要fillout賬號和密碼在登錄頁面
                   
            2. KKPortal提供CTI服務（呼叫）和門戶服務（網頁瀏覽）

            3.除門戶服務，您可以刪除別人，如果你不需要它。 （例如，如果你不需要CTI服務
            """
            , defaultValue: """
            Note
            0. KKPortal limit user must be a Plone user, if you don't have Plone website, please apply it.

            1. KKPortal use plone authorization to login, if your plone website is not public, besides providing config link you also need to fillout account and password in login page
                   
            2. KKPortal provide cti service (call) and portal service (web surfing)

            3. Except for portal service, you can remove others if you don't need it. (e.g. if you don‘t need cti service
            """
        )
        let text = """
        \(startUseTitle)
        
        \(startUseContentOne)

        {
            "meta": {
                "data_count": 0,
                "total_count": 0
            },
            "data": {
                "login": {
                    "url": "{{plone url host}}/Plone/@@app_login",
                    "auth_n": "basic",
                    "auth_z": "plone"
                },
                "services": [
                    {
                        "name": "twilio",
                        "type": "cti",
                        "url": {{url to get twilio access token}}
                    },
                    {
                        "name": "plone",
                        "type": "portal",
                        "url": "{{plone url host}}/Plone"
                    }
                ]
            },
            "status": {
                "code": "0000",
                "message": "success",
                "detail": "success"
            }
        }
        
        \(startUseContentTwo)
        
        \(startUseContentThree)
        ...
            },
                "services": [
                    {
                        "name": "plone",
                        "type": "portal",
                        "url": "{{plone url host}}/Plone"
                    }
                ]
            },
        ....
        )
        """
        let nsText = NSString(string: text)
        let contentRange = nsText.range(of: text)
        let titleRange = nsText.range(of: startUseTitle)
        let attriText = NSMutableAttributedString(string: text)
        attriText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: contentRange)
        attriText.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), range: contentRange)
        attriText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: titleRange)
        attriText.addAttribute(.foregroundColor, value: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), range: titleRange)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attriText.addAttribute(.paragraphStyle, value: paragraphStyle, range: titleRange)
        
        startUseTextView.attributedText = attriText
    }
    
    // 🎬 set action
    private func setAction() {
        comfirmButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
}
