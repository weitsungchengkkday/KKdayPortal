//
//  TwilioSpecViewController.swift
//  KKdayPortal
//
//  Created by KKday on 2021/4/23.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

final class TwilioSpecViewController: UIViewController {

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
    
    lazy var specTextField: UITextView = {
        let txv = UITextView()
        txv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        txv.layer.cornerRadius = 20
        txv.font = UIFont.boldSystemFont(ofSize: 16)
        txv.textColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        txv.isEditable = false
        
        let text = """
        Spec

        1. iOS SDK Version:
            . TwilioVoice 6.2.1

        When you use KKPortal, you need provide your twilio accessToken URL in config data.
        """
        let nsText = NSString(string: text)
        let contentRange = nsText.range(of: text)
        let titleRange = nsText.range(of: "Spec")
        
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
        btn.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 0.7506153682)
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setAction()
        bindViewModel()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        
        self.view.addSubview(backgroundImageVeiw)
        self.view.addSubview(specStackView)
        specStackView.addArrangedSubview(specTextField)
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
        
        specTextField.snp.makeConstraints { maker in
            maker.width.equalToSuperview().offset(-10)
        }
        
        comfirmButton.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.width.equalToSuperview().offset(-40)
        }
    }
    
    // 🧾 localization
    private func localizedText() {}
    
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
