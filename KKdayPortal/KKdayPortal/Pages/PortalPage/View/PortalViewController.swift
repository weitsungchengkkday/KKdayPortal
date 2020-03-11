//
//  HomeViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/21.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PortalViewController: UIViewController, Localizable {
    
    // 🏞 UI element
    private lazy var portalContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var observerLanguageChangedNotification: NSObjectProtocol?
    
    func refreshLanguage(_ nofification: Notification) {
        localizedText()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setAction()
        reigisterLanguageManager()
        addChildViewController()
    }
    
    deinit {
        unregisterLanguageManager()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        self.title = "Portal"
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        localizedText()
        
        self.view.addSubview(portalContainerView)
        portalContainerView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide)
            maker.leading.equalTo(view.safeAreaLayoutGuide)
            maker.trailing.equalTo(view.safeAreaLayoutGuide)
            maker.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func addChildViewController() {
        
        let rootURL: URL
        let resourceType = PloneResourceManager.shared.resourceType
        
        switch resourceType {
        case .kkMember:
#if SIT_VERSION
        rootURL = URL(string: "https://sit.eip.kkday.net/Plone/zh-tw")!
        
#elseif PRODUCTION_VERSION
        rootURL = URL(string: "https://eip.kkday.net/Plone/zh-tw")!

#else
        

#endif
        case .normal(url: let url):
            rootURL = URL(string: url.absoluteString + "/zh-tw")!
            print(rootURL)
        case .none:
            print("❌, resourceType must be defined")
            return
        }
        
        let viewModel = GeneralRootWithLanguageFoldersViewModel(source: rootURL)
        let childViewController = GeneralRootWithLanguageFoldersViewController(viewModel: viewModel)
        addChild(childViewController)
        childViewController.view.frame = portalContainerView.bounds
        portalContainerView.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
        
    }
    
    // 🧾 localization
    private func localizedText() {
        
    }
    
    // 🎬 set action
    private func setAction() {
        
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        
    }
}
