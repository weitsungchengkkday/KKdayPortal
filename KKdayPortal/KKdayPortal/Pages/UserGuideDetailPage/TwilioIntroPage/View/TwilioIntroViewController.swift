//
//  TwilioIntroViewController.swift
//  KKdayPortal
//
//  Created by KKday on 2021/4/23.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

final class TwilioIntroViewController: UIViewController, Localizable {
    
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
        bindViewModel()
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
        
        let urlOne: URL = URL(string: "https://www.twilio.com/")!
        let urlTwo: URL = URL(string: "https://www.twilio.com/docs/chat/create-tokens")!
        let urlThree: URL = URL(string: "https://www.twilio.com/docs/voice/twiml")!
        
        let twilioIntroTitle = "Twilio Intro".localize("Twilio簡介", defaultValue: "Twilio Intro")
        let twilioContentOne = "twilio_intro_textview_content_one".localize("Twilio是為通信開發平台。我們可以創建連接客戶端的accessToken（iOS應用）到Twilio TwiML APP。", defaultValue: "Twilio is a developer platform for communications. We can create our accessToken for connecting client (iOS APP) to Twilio TwiML APP.")
        let twilioContentTwo = "twilio_intro_textview_content_two".localize("1.什麼是Twilio？：", defaultValue: "1. What is Twilio?:")
        let twilioContentThree = "twilio_intro_textview_content_three".localize("2.如何創建twilio訪問令牌？：", defaultValue: "2. How to create twilio access token?:")
        let twilioContentFour = "twilio_intro_textview_content_four".localize("3.什麼是TwiML APP ?:", defaultValue: "3. What is TwiML APP?:")
        
        let text = """
        \(twilioIntroTitle)
        
        \(twilioContentOne)
        
        \(twilioContentTwo)
            \(urlOne.absoluteString)
        
        \(twilioContentThree)
           \(urlTwo.absoluteString)
               
        \(twilioContentFour)
           \(urlThree.absoluteString)
        """
        let nsText = NSString(string: text)
        let contentRange = nsText.range(of: text)
        let titleRange = nsText.range(of: twilioIntroTitle)
        
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
