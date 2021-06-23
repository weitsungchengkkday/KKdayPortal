//
//  PloneSpecViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/23.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

final class PloneSpecViewController: UIViewController, Localizable {
    
    // 🏞 UI element
    
    lazy var backgroundImageVeiw: UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "icIntroductionPageBackground")
        imv.contentMode = .scaleAspectFill
        return imv
    }()
    
    lazy var specStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.distribution = .fill
        stv.alignment = .center
        stv.spacing = 60
        return stv
    }()
    
    lazy var specTextView: UITextView = {
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
        btn.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 0.7506153682)
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
        bindViewModel()
    }
    
    deinit {
        unregisterLanguageManager()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        
        localizedText()
        
        self.view.addSubview(backgroundImageVeiw)
        self.view.addSubview(specStackView)
        specStackView.addArrangedSubview(specTextView)
        specStackView.addArrangedSubview(comfirmButton)
        
        backgroundImageVeiw.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        specStackView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(60)
            maker.leading.equalToSuperview().offset(30)
            maker.trailing.equalToSuperview().offset(-30)
            maker.bottom.equalToSuperview().offset(-60)
        }
        
        specTextView.snp.makeConstraints { maker in
            maker.width.equalToSuperview().offset(-10)
        }
        
        comfirmButton.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.width.equalToSuperview().offset(-40)
        }
    }
    
    // 🧾 localization
    private func localizedText() {
        comfirmButton.setTitle("general_ok".localize("好", defaultValue: "OK"), for: .normal)
        
        let ploneSpecTitle = "plone_spec_textview_title".localize("規格", defaultValue: "Spec")
        
        let ploneSpecContent = "plone_spec_textview_content".localize("""
            1.支持Plone的版本：
            。 5.1.6的Plone
            。 CMF 2.2.13
            。 Zope的29年2月13日
            。 Python的2.7.12
            。 PIL 6.1.0
        
        2.必須安裝的Plone擴展模塊：
            。 plone.restapi（REST的超媒體API為Plone  - （plone.restapi 5.1.0））
            。多語言支持（多語言模塊功能 - （plone.app.multilingual 5.2.3）
               
        3.當前支持Plone的語言：
            。 ZH-TW（繁體中文）

        當您使用KKPortal，您需要提供配置數據你的Plone主機URL。
        """, defaultValue: """
            1. Support Plone Version:
                . Plone 5.1.6
                . CMF 2.2.13
                . Zope 2.13.29
                . Python 2.7.12
                . PIL 6.1.0
            
            2. Must install Plone Expansion Module:
                . plone.restapi (RESTful hypermedia API for Plone. – (plone.restapi 5.1.0))
                . Multilingual Support(Multi-language module function – (plone.app.multilingual 5.2.3)
                   
            3. Current Support Plone Language:
                . zh-tw (繁體中文)

            When you use KKPortal, you need provide your plone host URL in config data.
        """)
            
        let text = """
        \(ploneSpecTitle)
        
        \(ploneSpecContent)
        """
        let nsText = NSString(string: text)
        let contentRange = nsText.range(of: text)
        let titleRange = nsText.range(of: ploneSpecTitle)
        
        let attriText = NSMutableAttributedString(string: text)
        attriText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: contentRange)
        attriText.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), range: contentRange)
        attriText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: titleRange)
        attriText.addAttribute(.foregroundColor, value: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), range: titleRange)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attriText.addAttribute(.paragraphStyle, value: paragraphStyle, range: titleRange)
        
        specTextView.attributedText = attriText
    }
    
    // 🎬 set action
    private func setAction() {
        comfirmButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {}
}
