//
//  OpenApplicationsEntryViewController.swift
//  KKdayPortal
//
//  Created by KKday on 2021/1/18.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit

final class OpenApplicationsEntryViewController: UIViewController {
    
    // 🏞 UI element
    lazy var applicationsStackView: UIStackView = {
        let stv: UIStackView = UIStackView()
        stv.axis = .vertical
        stv.alignment = .center
        stv.distribution = .fill
        stv.spacing = 50
        return stv
    }()
    
    lazy var twilioInroButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Call Center Info", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    lazy var twilioSettingButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Call Center Setting", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    lazy var twilioButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Call Center", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    lazy var twilioNoteLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        lbl.text = """
            1. Must set Call Center Setting before go to Call Center
            2. More information, please refer to the Call Center Info
        """
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let viewModel = OpenApplicationsEntryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setAction()
        bindViewModel()
        viewModel.loadPortalData()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        self.title = "Service"
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        view.addSubview(applicationsStackView)
        applicationsStackView.addArrangedSubview(twilioSettingButton)
        applicationsStackView.addArrangedSubview(twilioButton)
        applicationsStackView.addArrangedSubview(twilioInroButton)
        view.addSubview(twilioNoteLabel)
        
        applicationsStackView.snp.makeConstraints { maker in
            maker.width.equalToSuperview()
            maker.centerX.centerY.equalToSuperview()
        }
        
        twilioInroButton.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.width.equalToSuperview().offset(-60)
        }
        
        twilioSettingButton.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.width.equalToSuperview().offset(-60)
        }
        
        twilioButton.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.width.equalToSuperview().offset(-60)
        }
        
        twilioNoteLabel.snp.makeConstraints { maker in
            maker.top.equalTo(applicationsStackView.snp.bottom).offset(10)
            maker.width.equalToSuperview().offset(-60)
            maker.centerX.equalToSuperview()
        }
        
    }
    
    // 🎬 set action
    private func setAction() {
        twilioInroButton.addTarget(self, action: #selector(goTwilioInfo), for: .touchUpInside)
        twilioButton.addTarget(self, action: #selector(goTwilio), for: .touchUpInside)
        twilioSettingButton.addTarget(self, action: #selector(goTwilioSetting), for: .touchUpInside)
        
    }
    
    @objc private func goTwilioInfo() {
        let presentVC = OpenTwilioInfoViewController()
        present(presentVC, animated: true, completion: nil)
    }
    
    @objc private func goTwilio() {
        let presentVC = TwilioServiceManager.shared.twiVC
        present(presentVC, animated: true, completion: nil)
    }
    
    @objc private func goTwilioSetting() {
        
        let presentVC = OpenTwilioSettingViewController(viewModel: OpenTwilioSettingViewModel())
        present(presentVC, animated: true, completion: nil)
    }
    
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        viewModel.updateContent = { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.updateApplicationEntry(viewModel: weakSelf.viewModel)
        }
    }
    
    private func updateApplicationEntry(viewModel: OpenApplicationsEntryViewModel) {
  
    }
    

}
