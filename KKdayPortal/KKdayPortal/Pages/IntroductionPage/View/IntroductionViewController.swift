//
//  IntroductionViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/23.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

final class IntroductionViewController: UIViewController {

    // 🏞 UI element
    
    lazy var backgroundImageVeiw: UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "icLoginPageBackground-two")
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
    
    lazy var noticeTextField: UITextView = {
        let txv = UITextView()
        txv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
        txv.layer.cornerRadius = 20
        txv.font = UIFont.boldSystemFont(ofSize: 16)
        txv.text = """
        Notice
        
        0. KKPortal is a iOS APP for present Plone Website Content
        
        1. Support Plone Version:
            Plone 5.1.6
            CMF 2.2.13
            Zope 2.13.29
            Python 2.7.12
            PIL 6.1.0
        
        2. Must support Plone Expansion Module:
            a. plone.restapi (RESTful hypermedia API for Plone. – (plone.restapi 5.1.0))
            b. Multilingual Support(Multi-language module function – (plone.app.multilingual 5.2.3)
               
        3. Current Support Plone Language:
            zh-tw
        """
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
        self.view.addSubview(noticeStackView)
        noticeStackView.addArrangedSubview(noticeTextField)
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
        
        noticeTextField.snp.makeConstraints { maker in
            maker.width.equalTo(self.view.snp.width).offset(-50)
        }
        
        comfirmButton.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.width.equalTo(self.view.snp.width).offset(-100)
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
