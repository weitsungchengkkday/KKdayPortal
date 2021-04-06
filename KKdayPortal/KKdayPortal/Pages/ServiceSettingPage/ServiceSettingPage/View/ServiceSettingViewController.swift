//
//  ServiceSettingViewController.swift
//  KKdayPortal
//
//  Created by KKday on 2021/3/26.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit

final class ServiceSettingViewController: UIViewController {
    
    // 🏞 UI element
    
    lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "icMenuClosePrimary"), for: .normal)
        return btn
    }()

    lazy var twilioSettingStackView: UIStackView = {
        let stv: UIStackView = UIStackView()
        stv.axis = .vertical
        stv.alignment = .leading
        stv.distribution = .fill
        stv.spacing = 5
        return stv
    }()
    
    lazy var twilioAccessTokenURLLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.text = "Twilio AccessToken URL"
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var twilioAccessTokenURLTextField: UITextField = {
        let txf = UITextField()
        txf.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        txf.keyboardType = .default
        txf.borderStyle = .roundedRect
        txf.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return txf
    }()
    
    lazy var deleteOrCheckStackView: UIStackView = {
        let stv: UIStackView = UIStackView()
        stv.axis = .horizontal
        stv.alignment = .center
        stv.distribution = .fill
        stv.spacing = 20
        return stv
    }()
    
    lazy var twilioAccessTokenAPIDeleteButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.setBackgroundImage(UIImage(systemName: "x.circle.fill") ?? #imageLiteral(resourceName: "icPicture"), for: .normal)
        return btn
    }()
    
    lazy var twilioAccessTokenAPISaveButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.setBackgroundImage(UIImage(systemName: "checkmark.circle.fill") ?? #imageLiteral(resourceName: "icPicture"), for: .normal)
        return btn
    }()
    
    lazy var currentServiceSettingLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.text = "Current Service Setting"
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var currentSettingTextView: UITextView = {
        let txv = UITextView()
        txv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        txv.layer.cornerRadius = 20
        txv.font = UIFont.boldSystemFont(ofSize: 16)
        txv.textColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        txv.isEditable = false
        txv.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        txv.layer.borderWidth = 2
        txv.layer.cornerRadius = 10
        
        return txv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setAction()
        readCurrentSetting()
       
    }
    
    private func setupUI() {
        self.title = "Service Setting"
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        self.view.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { maker in
            maker.width.height.equalTo(20)
            maker.top.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
        }
    
        self.view.addSubview(twilioSettingStackView)
        twilioSettingStackView.addArrangedSubview(twilioAccessTokenURLLabel)
        twilioSettingStackView.addArrangedSubview(twilioAccessTokenURLTextField)

        twilioSettingStackView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(60)
            maker.centerX.equalToSuperview()
            maker.width.equalToSuperview().offset(-60)
        }
        
        twilioAccessTokenURLTextField.snp.makeConstraints { maker in
            maker.width.equalToSuperview()
        }
        
        self.view.addSubview(deleteOrCheckStackView)
        deleteOrCheckStackView.addArrangedSubview(twilioAccessTokenAPIDeleteButton)
        deleteOrCheckStackView.addArrangedSubview(twilioAccessTokenAPISaveButton)
        
        deleteOrCheckStackView.snp.makeConstraints { maker in
            maker.top.equalTo(twilioSettingStackView.snp.bottom).offset(5)
            maker.trailing.equalTo(twilioSettingStackView.snp.trailing)
        }
        
        twilioAccessTokenAPIDeleteButton.snp.makeConstraints { maker in
            maker.size.equalTo(40)
        }
        
        twilioAccessTokenAPISaveButton.snp.makeConstraints { maker in
            maker.size.equalTo(40)
        }
        
        self.view.addSubview(currentServiceSettingLabel)
        currentServiceSettingLabel.snp.makeConstraints { maker in
            maker.top.equalTo(deleteOrCheckStackView.snp.bottom).offset(20)
            maker.leading.equalTo(twilioSettingStackView)
        }
        
        self.view.addSubview(currentSettingTextView)
        currentSettingTextView.snp.makeConstraints { maker in
            maker.top.equalTo(currentServiceSettingLabel.snp.bottom).offset(5)
            maker.width.equalToSuperview().offset(-60)
            maker.height.equalTo(400)
            maker.leading.equalTo(twilioSettingStackView)
        }
        
    }
    
    private func readCurrentSetting() {
        
        let twilioAccessTokenURL: String? = StorageManager.shared.load(for: .customTwilioAccessTokenURL)
        currentSettingTextView.text = """
            <Current Service>
            TwilioAccessTokenURL: \(twilioAccessTokenURL ?? "")
            """
    }
    
    // 🎬 set action
    private func setAction() {
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        
        twilioAccessTokenAPIDeleteButton.addTarget(self, action: #selector(deleteTwilioAccessTokenURL), for: .touchUpInside)
        
        twilioAccessTokenAPISaveButton.addTarget(self, action: #selector(saveTwilioAccessTokenURL), for: .touchUpInside)
        
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveTwilioAccessTokenURL() {
        StorageManager.shared.save(for: .customTwilioAccessTokenURL, value: twilioAccessTokenURLTextField.text)
        readCurrentSetting()
    }
    
    @objc private func deleteTwilioAccessTokenURL() {
        StorageManager.shared.save(for: .customTwilioAccessTokenURL, value: "")
        twilioAccessTokenURLTextField.text = ""
        readCurrentSetting()
    }
}
