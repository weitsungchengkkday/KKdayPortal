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
    
    lazy var serviceSettingButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Service Setting", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    
    lazy var serviceManaulButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Service Manaul", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    private let viewModel = ServiceSettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setAction()
        bindViewModel()
        viewModel.loadPortalData()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        self.title = "Service Setting"
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        view.addSubview(applicationsStackView)
        applicationsStackView.addArrangedSubview(serviceSettingButton)
        applicationsStackView.addArrangedSubview(serviceManaulButton)
        
        applicationsStackView.snp.makeConstraints { maker in
            maker.width.equalToSuperview()
            maker.centerX.centerY.equalToSuperview()
        }
        
        serviceManaulButton.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.width.equalToSuperview().offset(-60)
        }
        
        serviceSettingButton.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.width.equalToSuperview().offset(-60)
        }
        
    }
    
    // 🎬 set action
    private func setAction() {
        
        serviceSettingButton.addTarget(self, action: #selector(goServiceSetting), for: .touchUpInside)
        
        serviceManaulButton.addTarget(self, action: #selector(goServiceManaul), for: .touchUpInside)
        
    }
    
    
    @objc private func goServiceSetting() {
        let presentVC = ServiceSettingViewController()
        present(presentVC, animated: true, completion: nil)
    }
    
    @objc private func goServiceManaul() {
        let presentVC = ServiceManaulViewController()
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
    
    private func updateApplicationEntry(viewModel: ServiceSettingViewModel) {
  
    }
    

}
