//
//  GeneralLinkViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit
import SafariServices

final class GeneralLinkViewController: UIViewController, GeneralDetailPageCoordinator {
    
    // 🏞 UI element
    lazy var logoImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = UserResourceManager.shared.currentLogoImage
        return imv
    }()
    
    lazy var topTitleLabel: GeneralItemTopTitleLabel = {
        let lbl = GeneralItemTopTitleLabel()
        return lbl
    }()
    
    lazy var openLinkButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("OpenLink", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    private let viewModel: GeneralLinkViewModel
    
    init(viewModel: GeneralLinkViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(alertIfNeeded), name: Notification.Name.alertEvent, object: nil)
        
        setupUI()
        setAction()
        bindViewModel()
        viewModel.loadPortalData()
    }
    
    @objc private func alertIfNeeded(_ notification: Notification) {
        if (notification.name == Notification.Name.alertEvent) {

        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.alertEvent, object: nil)
    }
    
    // 🎨 draw UI
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(logoImageView)
        view.addSubview(topTitleLabel)
        view.addSubview(openLinkButton)
        
        logoImageView.snp.makeConstraints { maker in
            maker.width.equalTo(140)
            maker.height.equalTo(79)
            maker.top.equalTo(self.view.snp.topMargin)
            maker.leading.equalToSuperview()
        }
        
        topTitleLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(logoImageView.snp.trailing)
            maker.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            maker.bottom.equalTo(logoImageView.snp.bottom).offset(-5)
        }
        
        openLinkButton.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
            maker.height.equalTo(44)
            maker.width.equalToSuperview().offset(-60)
        }
    }
    
    // 🎬 set action
    private func setAction() {
        openLinkButton.addTarget(self, action: #selector(openLink), for: .touchUpInside)
    }
    
    @objc private func openLink() {
        
        guard let url = viewModel.linkURL else {
            return
        }
        openOutSiteLink(url: url)
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        
        viewModel.updateContent = { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.updateLink(viewModel: weakSelf.viewModel)
        }
    }
    
    private func updateLink(viewModel: GeneralLinkViewModel) {
        self.topTitleLabel.text = viewModel.linkTitle
    }
}
