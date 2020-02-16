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
        
        #if TEST_VERSION || SIT_VERSION
        guard let url = URL(string: "https://sit.eip.kkday.net/Plone/zh-tw") else {
            print("❌, not valid root url")
            return
        }
        
        #elseif PRODUCTION_VERSION
        guard let url = URL(string: "https://eip.kkday.net/Plone/zh-tw") else {
            print("❌, not valid root url")
            return
        }
        
        #else
        
        
        #endif
        
        rootURL = url
        
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
