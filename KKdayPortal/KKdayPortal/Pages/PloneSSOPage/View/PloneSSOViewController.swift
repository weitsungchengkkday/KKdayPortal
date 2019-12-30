//
//  PloneSSOViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/19.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import WebKit

final class PloneSSOViewController: UIViewController {

    // 🏞 UI element
    lazy var webView: WKWebView = {
        let contentController = WKUserContentController()
        contentController.add(self, name: "userLogin")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let wkv = WKWebView(frame: self.view.bounds, configuration: config)
        wkv.navigationDelegate = self
        
        return wkv
    }()
    
      lazy var loginButton: UIButton = {
           let btn = UIButton()
           btn.setTitle("Login", for: .normal)
           btn.backgroundColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
           btn.layer.cornerRadius = 4
           return btn
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setAction()
        bindViewModel()
        
        #if DEBUG
            goMainViewController()
        #elseif RELEASE
            let url = URL(string: "https://sit.eip.kkday.net/Plone/@@app_login")!
            webView.load(URLRequest(url: url))
        #else
        
        #endif
    }
    
    // 🎨 draw UI
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        view.addSubview(webView)
        view.addSubview(loginButton)
        webView.snp.makeConstraints { maker in
            maker.trailing.leading.top.bottom.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints { maker in
           maker.top.equalTo(webView.snp.bottom).offset(20)
            maker.centerX.equalToSuperview()
        }
        
        #if DEBUG
        
        #elseif RELEASE
           loginButton.isHidden = true
        #else
           
        #endif
        
    }
    
    // 🧾 localization
    private func localizedText() {}
    
    // 🎬 set action
    private func setAction() {
        loginButton.addTarget(self, action: #selector(goMainViewController), for: .touchUpInside)
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {}
    
    
    @objc func goMainViewController() {
        let presentViewController = MainViewController()
        present(presentViewController, animated: true, completion: nil)
    }
}

extension PloneSSOViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    
        // Get User Login Info
        // With Plone Web Site (using SAML SSO)
        // Web Site Post Message with JWT Token and email
        if (message.name == "userLogin"){
            if let body = message.body as? [String : Any],
                let account = body["id"] as? String,
                let token = body["token"] as? String {
                
                let user = GeneralUser(account: account, password: "", token: token)
                StorageManager.shared.saveObject(for: .generalUser, value: user)
                goMainViewController()
                
            } else {
                // Alert User Can't Login
            }
        }
        
    }
}


extension PloneSSOViewController: WKNavigationDelegate {
 
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
    
        print("📮 Navigation Response: \(navigationResponse.response)")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        print("🔗 NavigationType: \(navigationAction.navigationType.description)")
        if navigationAction.navigationType == .linkActivated {
            
            if let url = navigationAction.request.url {
                print("🌐 Navigation URL: \(url)")
            }
            
            decisionHandler(.allow)
        } else {
            decisionHandler(.allow)
        }
    }
}


