//
//  PloneIntroductionViewController.swift
//  KKdayPortal-Sit
//
//  Created by WEI-TSUNG CHENG on 2020/3/4.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

final class PloneIntroViewController: UIViewController, Localizable {
    
    // 🏞 UI element
    
    lazy var backgroundImageVeiw: UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "icIntroductionPageBackground")
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
        let urlOne: URL = URL(string: "https://docs.plone.org/intro/index.html")!
        let urlTwo: URL = URL(string: "https://docs.plone.org/quickstart/index.html")!
        let urlThree: URL = URL(string: "https://docs.plone.org/working-with-content/index.html")!
        
        let ploneIntroTitle = "plone_intro_textview_title".localize("Plone的介紹", defaultValue: "Plone Intro")
        let ploneIntroContentOne = "plone_intro_textview_content_one".localize("""
        Plone的是建立在Zope的應用服務器之上的自由和開放源碼的內容管理系統。 Plone的定位為“企業網站管理系統”，通常用於企業內部網和大型企業的網站存在的一部分。 （來源：https://zh.wikipedia.org/wiki/Plone）
        """, defaultValue: """
        Plone is a free and open source content management system built on top of the Zope application server. Plone is positioned as an "Enterprise CMS" and is commonly used for intranets and as part of the web presence of large organizations. (source : https://zh.wikipedia.org/wiki/Plone)
        """)
        let ploneIntroContentTwo = "plone_intro_textview_content_two".localize("1.什麼是Plone的？：", defaultValue: "1. What is Plone?:")
        let ploneIntroContentThree = "plone_intro_textview_content_three".localize("2.如何快速啟動Plone的網站？：", defaultValue: "2. How to quick start Plone Website?:")
        let ploneIntroContentFour = "plone_intro_textview_content_four".localize("3.如何與Plone的內容合作？：", defaultValue: "3. How to work with Plone content?:")
        
        let text = """
        \(ploneIntroTitle)
        
        \(ploneIntroContentOne)
        
        \(ploneIntroContentTwo)
           \(urlOne.absoluteString)
        
        \(ploneIntroContentThree)
           \(urlTwo.absoluteString)
               
        \(ploneIntroContentFour)
           \(urlThree.absoluteString)
        """
        let nsText = NSString(string: text)
        let contentRange = nsText.range(of: text)
        let titleRange = nsText.range(of: ploneIntroTitle)
        
        let linkRangeOne = nsText.range(of: urlOne.absoluteString)
        let linkRangeTwo = nsText.range(of: urlTwo.absoluteString)
        let linkRangeThree = nsText.range(of: urlThree.absoluteString)
        
        let attriText = NSMutableAttributedString(string: text)
        attriText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: contentRange)
        attriText.addAttribute(.foregroundColor, value: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), range: contentRange)
        attriText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: titleRange)
        attriText.addAttribute(.foregroundColor, value: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), range: titleRange)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attriText.addAttribute(.paragraphStyle, value: paragraphStyle, range: titleRange)
        
        attriText.addAttribute(.link, value: urlOne.absoluteString, range: linkRangeOne)
        attriText.addAttribute(.link, value: urlTwo.absoluteString, range: linkRangeTwo)
        attriText.addAttribute(.link, value: urlThree.absoluteString, range: linkRangeThree)
        
        txv.attributedText = attriText
        return txv
    }()
    
    lazy var comfirmButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.5818830132, green: 0.2156915367, blue: 1, alpha: 0.5)
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
