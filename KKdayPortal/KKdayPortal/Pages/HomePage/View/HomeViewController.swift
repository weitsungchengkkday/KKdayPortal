//
//  HomeViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/14.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class HomeViewController: UIViewController, Localizable {
    
    // 🏞 UI element
    private lazy var homeContainerView: UIView = {
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
        self.title = "Home"
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        localizedText()
        
        self.view.addSubview(homeContainerView)
        homeContainerView.snp.makeConstraints { maker in
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
            rootURL = URL(string: ConfigManager.shared.model.host + "/Plone" + "/zh-tw")!
            
        case .normal(url: let url):
            rootURL = URL(string: url.absoluteString + "/zh-tw")!
            
        case .none:
            print("❌, resourceType must be defined")
            return
        }
        
        
        let viewModel = GeneralRootWithLanguageDocumentViewModel(source: rootURL)
        let childViewController = GeneralRootWithLanguageDocumentViewController(viewModel: viewModel)
        addChild(childViewController)
        childViewController.view.frame = homeContainerView.bounds
        
        homeContainerView.addSubview(childViewController.view)
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
