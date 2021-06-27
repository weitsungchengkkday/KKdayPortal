//
//  ServiceListViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/18.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit

final class ServiceListViewController: UIViewController, Localizable, NetStatusProtocal {
    
    // 🏞 UI element
    lazy var servicesStackView: UIStackView = {
        let stv: UIStackView = UIStackView()
        stv.axis = .vertical
        stv.alignment = .center
        stv.distribution = .fill
        stv.spacing = 50
        return stv
    }()
    
    lazy var callCenterButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    var observerLanguageChangedNotification: NSObjectProtocol?
    
    func refreshLanguage(_ nofification: Notification) {
        localizedText()
    }
    
    private let viewModel = ServiceListViewModel()
    
    var observerNetStatusChangedNotification: NSObjectProtocol?
    
    func noticeNetStatusChanged(_ nofification: Notification) {
        checkNetStatusSnackBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setAction()
        registerLanguageManager()
        registerNetStatusManager()
        bindViewModel()
        viewModel.loadPortalData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkNetStatusSnackBar()
    }
    
    deinit {
        unregisterNetStatusManager()
        unregisterLanguageManager()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        localizedText()
        
        view.addSubview(servicesStackView)
        
        // Hidden Servicd Button if it is not available
        guard let config: PortalConfig = StorageManager.shared.loadObject(for: .portalConfig) else {
            print("❌ NO PortalConfig")
            fatalError()
        }
        
        let servicesArray: [String] = config.data.services.map { service -> String in
            return service.type
        }
        
        if servicesArray.contains("cti") {
            servicesStackView.addArrangedSubview(callCenterButton)
            callCenterButton.snp.makeConstraints { maker in
                maker.height.equalTo(44)
                maker.width.equalToSuperview().offset(-60)
            }
        }
        
        servicesStackView.snp.makeConstraints { maker in
            maker.width.equalToSuperview()
            maker.centerX.centerY.equalToSuperview()
        }
        
    }
    
    // 🧾 localization
    private func localizedText() {
        self.title = "service_list_title".localize("服務列表", defaultValue: "Service List")
        
        callCenterButton.setTitle("service_button_phone".localize("KK 電話", defaultValue: "KK Phone"), for: .normal)
    }
    
    // 🎬 set action
    private func setAction() {
        
        callCenterButton.addTarget(self, action: #selector(goCallCenter), for: .touchUpInside)
    }
    
    @objc private func goCallCenter() {
        let presentVC = TwilioServiceManager.shared.twiVC
        present(presentVC, animated: true, completion: nil)
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        viewModel.updateContent = { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.updateServiceList(viewModel: weakSelf.viewModel)
        }
    }
    
    private func updateServiceList(viewModel: ServiceListViewModel) {
        
    }
}
