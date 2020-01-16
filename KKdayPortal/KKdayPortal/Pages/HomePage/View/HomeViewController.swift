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

final class HomeViewController: UIViewController, Localizable {
    
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
        
#if TEST_VERSION
                let rootURL = URL(string: "http://localhost:8080/pikaPika")!
        
#elseif SIT_VERSION
                let rootURL = URL(string: "https://sit.eip.kkday.net/Plone/zh-tw")!
        
#elseif PRODUCTION_VERSION
                let rootURL = URL(string: "https://eip.kkday.net/Plone/zh-tw")!
        
#else
        
#endif
        
        let viewModel = GeneralRootWithLanguageViewModel(source: rootURL)
        let childViewController = GeneralRootWithLanguageViewController(viewModel: viewModel)
        
        let navigationController = GeneralRootWithLanguageNavigationController()
        navigationController.viewControllers = [childViewController]
        navigationController.navigationBar.isHidden = true
        
        addChild(navigationController)
        navigationController.view.frame = homeContainerView.bounds
        homeContainerView.addSubview(navigationController.view)
        navigationController.didMove(toParent: self)
        
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
