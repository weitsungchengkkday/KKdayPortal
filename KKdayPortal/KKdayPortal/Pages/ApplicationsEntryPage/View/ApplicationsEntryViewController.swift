//
//  ApplicationsEntryViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/18.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit

final class ApplicationsEntryViewController: UIViewController {
    
    private static var CellName: String {
        return "EntryCell"
    }
    
    // 🏞 UI element
    lazy var applicationsStackView: UIStackView = {
        let stv: UIStackView = UIStackView()
        stv.axis = .vertical
        stv.alignment = .center
        stv.distribution = .fill
        stv.spacing = 50
        return stv
    }()
    
    lazy var bpmButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("BPM", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    lazy var twilioButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Call Center", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    private let viewModel = ApplicationsEntryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setAction()
        bindViewModel()
        viewModel.loadPortalData()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        self.title = "Service List"
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        view.addSubview(applicationsStackView)
        applicationsStackView.addArrangedSubview(bpmButton)
        applicationsStackView.addArrangedSubview(twilioButton)
        
        applicationsStackView.snp.makeConstraints { maker in
            maker.width.equalToSuperview()
            maker.centerX.centerY.equalToSuperview()
        }
        
        bpmButton.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.width.equalToSuperview().offset(-60)
        }
        
        twilioButton.snp.makeConstraints { maker in
            maker.height.equalTo(44)
            maker.width.equalToSuperview().offset(-60)
        }
    }
    
    // 🎬 set action
    private func setAction() {
        bpmButton.addTarget(self, action: #selector(goBPM), for: .touchUpInside)
        twilioButton.addTarget(self, action: #selector(goTwilio), for: .touchUpInside)
    }
    
    @objc private func goBPM() {
        let bpmURL = URL(string: ConfigManager.shared.model.BPM + "/WebAgenda/")!
        let vm = ApplicationsContentViewModel(source: bpmURL)
        let presentVC = ApplicationsContentViewController(viewModel: vm)
        
        present(presentVC, animated: true, completion: nil)
    }
    
    @objc private func goTwilio() {
        let presentVC = TwilioServiceViewController()

        // 🍕 set PushKitEventDelegate to TwilioServiceViewController
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        delegate.pushKitEventDelegate = presentVC
        
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
    
    private func updateApplicationEntry(viewModel: ApplicationsEntryViewModel) {
  
    }
}
