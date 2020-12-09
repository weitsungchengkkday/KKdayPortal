//
//  TwilioServiceViewController.swift
//  KKdayPortal
//
//  Created by KKday on 2020/12/8.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit

final class TwilioServiceViewController: UIViewController {

    // 🏞 UI element
    
    lazy var qualityWarningsToaster: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.text = "Warnings Message"
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var placeCallButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.setBackgroundImage(UIImage(systemName: "phone.fill.arrow.up.right")!, for: .normal)
        
        return btn
    }()
    
    lazy var iconView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "headphones.circle.fill")
       
        return img
    }()
    
    lazy var outgoingValue: UITextField = {
        let txf = UITextField()
        txf.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        txf.keyboardType = .phonePad
        txf.borderStyle = .roundedRect
        txf.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
        return txf
    }()
    
    lazy var outgoingLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.text = "Input Call Information"
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var callControlView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 0)
        return view
    }()
    
    lazy var muteSwitch: UISwitch = {
        let swh = UISwitch()
        swh.isEnabled = true
        return swh
    }()
    
    lazy var muteLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.textAlignment = .center
        lbl.text = "Mute"
        
        return lbl
    }()
     
    lazy var speakerSwitch: UISwitch = {
        let swh = UISwitch()
        swh.isEnabled = true
        return swh
    }()
    
    lazy var speakerLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.textAlignment = .center
        lbl.text = "Speaker"
        
        return lbl
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setAction()
    }
    
    
    private func setupUI() {
        
        self.view.addSubview(qualityWarningsToaster)
        self.view.addSubview(iconView)
        self.view.addSubview(outgoingValue)
        self.view.addSubview(outgoingLabel)
        self.view.addSubview(placeCallButton)
        
        self.view.addSubview(callControlView)
        self.callControlView.addSubview(muteSwitch)
        self.callControlView.addSubview(muteLabel)
        self.callControlView.addSubview(speakerSwitch)
        self.callControlView.addSubview(speakerLabel)
        
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        qualityWarningsToaster.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.height.equalTo(18)
            maker.top.equalTo(self.view.snp.topMargin).offset(16)
            maker.width.equalTo(self.view.snp.width)
        }
        
        iconView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(-97.5)
            maker.width.equalTo(240)
            maker.height.equalTo(240)
        }
        
        outgoingValue.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(iconView.snp.bottom).offset(42.5)
            maker.width.equalTo(240)
        }
        
        outgoingLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(outgoingValue.snp.bottom).offset(8)
            maker.width.equalTo(256)
            maker.height.equalTo(40)
        }
        
        placeCallButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.width.height.equalTo(40)
            maker.top.equalTo(outgoingLabel.snp.bottom).offset(8)
        }
        
        callControlView.snp.makeConstraints { maker in
            maker.top.equalTo(placeCallButton.snp.bottom).offset(8)
            maker.centerX.equalToSuperview()
            maker.height.equalTo(88)
            maker.width.equalTo(240)
        }
        
        muteSwitch.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(12)
            maker.centerX.equalToSuperview().offset(-60)
        }
        
        muteLabel.snp.makeConstraints { maker in
            maker.centerX.equalTo(muteSwitch)
            maker.top.equalTo(muteSwitch.snp.bottom).offset(10)
        }
        
        speakerSwitch.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(12)
            maker.centerX.equalToSuperview().offset(60)
        }
        
        speakerLabel.snp.makeConstraints { maker in
            maker.centerX.equalTo(speakerSwitch)
            maker.top.equalTo(speakerSwitch.snp.bottom).offset(10)
        }
        
    }
    
    private func setAction() {
        placeCallButton.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        muteSwitch.addTarget(self, action: #selector(muteSwitchToggled), for: .valueChanged)
        
        speakerSwitch.addTarget(self, action: #selector(speakerSwitchToggled), for: .valueChanged)
    }
    
    @objc private func mainButtonPressed(sender: UIButton) {
        
    }
    
    @objc private func muteSwitchToggled(sender: UISwitch) {
        
    }
    
    @objc private func speakerSwitchToggled(sender: UISwitch) {
        
    }
    
    
    


}
