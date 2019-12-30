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

final class HomeViewController: UIViewController, GeneralItemCoordinator, Localizable {
    
    // 🏞 UI element
    lazy var webHomeButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Plone Home Page", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 4
        return btn
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
    }
    
    deinit {
        unregisterLanguageManager()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        localizedText()
        view.backgroundColor = UIColor.white
        view.addSubview(webHomeButton)
        webHomeButton.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(160)
        }
    }
    
    // 🧾 localization
    private func localizedText() {
        self.title = "common_main_page".localize("首頁")
    }
    
    // 🎬 set action
    private func setAction() {
        webHomeButton.addTarget(self, action: #selector(goWebHomePage), for: .touchUpInside)
    }

    @objc private func goWebHomePage() {

        #if TEST_VERSION
            let rootURL = URL(string: "http://localhost:8080/pikaPika")!
       
        #elseif SIT_VERSION
            let rootURL = URL(string: "https://sit.eip.kkday.net/Plone")!
        
        #elseif PRODUCTION_VERSION
            let rootURL = URL(string: "https://eip.kkday.net/Plone")!
        #else
        
        #endif
        
        goDetailPage(route: rootURL, type: .root)
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        
    }
}
