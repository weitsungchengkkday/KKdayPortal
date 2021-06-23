//
//  AboutViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/24.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

final class AboutViewController: UIViewController, Localizable {
    // 🏞 UI element
    
    lazy var backgroundImageVeiw: UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "icSettingPageBackground")
        imv.contentMode = .scaleAspectFill
        return imv
    }()
    
    lazy var noticeStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.distribution = .fill
        stv.alignment = .center
        stv.spacing = 60
        return stv
    }()
    
    lazy var noticeTextView: UITextView = {
        let txv = UITextView()
        txv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        txv.layer.cornerRadius = 20
        txv.font = UIFont.boldSystemFont(ofSize: 16)
        txv.textColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        txv.isEditable = false
        txv.delegate = self
        
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
        self.view.addSubview(noticeStackView)
        noticeStackView.addArrangedSubview(noticeTextView)
        noticeStackView.addArrangedSubview(comfirmButton)
        
        backgroundImageVeiw.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        noticeStackView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(60)
            maker.leading.equalToSuperview().offset(30)
            maker.trailing.equalToSuperview().offset(-30)
            maker.bottom.equalToSuperview().offset(-60)
        }
        
        noticeTextView.snp.makeConstraints { maker in
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
        
        let privacyPorlicyURL: URL = URL(string: "https://sites.google.com/kkday.com/privacy-porlicy-kkportal/%E9%9A%B1%E7%A7%81%E6%AC%8A%E6%94%BF%E7%AD%96")!
        
        let aboutTitle = "about_textview_title".localize("關於", defaultValue: "About")
        
        let aboutConentOne = "about_textview_title_content_one".localize("""
        KKPortal porvide的方式展示在iOS APP Plone的網站內容。這意味著Plone的科目（包括收集，事件，文件，文件夾，圖片，鏈接，新聞條目，頁）可以正常顯示用戶的手機上。
        """, defaultValue: """
        KKPortal porvide a way to show plone website content on iOS APP. That means plone subjects (including Collection, Event, File, Folder, Image, Link, News Item, Page) can be shown properly on user's cell phone.
        """)
        let aboutConentTwo = "about_textview_title_content_two".localize("（不支持視頻和音頻文件呈現到現在）", defaultValue: "(Not support video and audio file presenting by now)")
        
        let aboutContentThree = "about_textview_title_content_three".localize("""
        版本：1.0.0
                
        支持Plone的版本：5.1.6
                
        隱私政策：
        """, defaultValue: """
        Version: 1.0.0
        
        Support Plone Version: 5.1.6
        
        Privacy policy:
        """)
        
        let text = """
        \(aboutTitle)
        
        \(aboutConentOne)
        
        \(aboutConentTwo)
        
        \(aboutContentThree)
            \(privacyPorlicyURL.absoluteString)
        """
        let nsText = NSString(string: text)
        let contentRange = nsText.range(of: text)
        let titleRange = nsText.range(of: aboutTitle)
        let linkRange = nsText.range(of: privacyPorlicyURL.absoluteString)
        let noteRange = nsText.range(of: aboutConentTwo)
        
        let attriText = NSMutableAttributedString(string: text)
        attriText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: contentRange)
        attriText.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), range: contentRange)
        attriText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: titleRange)
        attriText.addAttribute(.foregroundColor, value: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), range: titleRange)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attriText.addAttribute(.paragraphStyle, value: paragraphStyle, range: titleRange)
        
        attriText.addAttribute(.link, value: privacyPorlicyURL.absoluteString, range: linkRange)
        attriText.addAttribute(.foregroundColor, value: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), range: noteRange)
        
        noticeTextView.attributedText = attriText
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

extension AboutViewController: UITextViewDelegate {
        
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
