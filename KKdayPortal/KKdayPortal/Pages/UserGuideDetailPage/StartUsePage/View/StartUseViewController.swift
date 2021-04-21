//
//  StartUseViewController.swift
//  KKdayPortal
//
//  Created by KKday on 2021/4/21.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

final class StartUseViewController: UIViewController {
    
    // 🏞 UI element
    
    lazy var startUseStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.distribution = .fill
        stv.alignment = .center
        stv.spacing = 60
        return stv
    }()
    
    lazy var startUseTextField: UITextView = {
        let txv = UITextView()
        txv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        txv.layer.cornerRadius = 20
        txv.font = UIFont.boldSystemFont(ofSize: 16)
        txv.textColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        txv.isEditable = false
        
        let text = """
        Start to use
        
        KKporal is start up by config data, user must provide link in order to get config data by HTTP [GET] method. Response data must can be utf-8 decode to String as below:

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
        
        # {{ .... }}  means, you need to provide your own Info
        
        Note
        0. KKPortal limit user must be a Plone user, if you don't have Plone website, please apply it.

        1. KKPortal use plone authorization to login, if your plone website is not public, besides providing config link you also need to fillout account and password in login page
               
        2. KKPortal provide cti service (call) and portal service (web surfing)

        3. Except for portal service, you can remove others if you don't need it. (e.g. if you don‘t need cti service
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
        let titleRange = nsText.range(of: "Start to use")
        
        let attriText = NSMutableAttributedString(string: text)
        attriText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: contentRange)
        attriText.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), range: contentRange)
        attriText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: titleRange)
        attriText.addAttribute(.foregroundColor, value: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), range: titleRange)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attriText.addAttribute(.paragraphStyle, value: paragraphStyle, range: titleRange)
        
        txv.attributedText = attriText
        return txv
    }()
    
    lazy var comfirmButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        btn.setTitle("OK", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        btn.layer.cornerRadius = 5
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setAction()
    }
    
    private func setupUI() {
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.view.addSubview(startUseStackView)
        startUseStackView.addArrangedSubview(startUseTextField)
        startUseStackView
            .addArrangedSubview(comfirmButton)
        startUseStackView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(60)
            maker.leading.equalToSuperview().offset(30)
            maker.trailing.equalToSuperview().offset(-30)
            maker.bottom.equalToSuperview().offset(-60)
        }
        
        startUseTextField.snp.makeConstraints { maker in
            maker.width.equalTo(self.view.snp.width).offset(-50)
        }
        
        comfirmButton.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.width.equalTo(self.view.snp.width).offset(-100)
        }
    }
    
    // 🎬 set action
    private func setAction() {
        comfirmButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
}
