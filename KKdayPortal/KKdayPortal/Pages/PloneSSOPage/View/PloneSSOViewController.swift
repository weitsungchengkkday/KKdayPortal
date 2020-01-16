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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setAction()
        bindViewModel()
        
#if SIT_VERSION
            let url = URL(string: "https://sit.eip.kkday.net/Plone/@@app_login")!
            webView.load(URLRequest(url: url))
      
#elseif PRODUCTION_VERSION
            let url = URL(string: "https://eip.kkday.net/Plone/@@app_login")!
            webView.load(URLRequest(url: url))
       
#else
        
#endif
    }
    
    // 🎨 draw UI
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(webView)
        
        webView.snp.makeConstraints { maker in
            maker.trailing.leading.top.bottom.equalToSuperview()
        }
    }
    
    // 🧾 localization
    private func localizedText() {}
    
    // 🎬 set action
    private func setAction() {}
    
    // ⛓ bind viewModel
    private func bindViewModel() {}
    
    private func goMainViewController() {
        let presentViewController = MainViewController()
        presentViewController.modalPresentationStyle = .fullScreen
        present(presentViewController, animated: true, completion: nil)
    }
}

extension PloneSSOViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    
        // Get User Login Info
        // With Plone Web Site (using SAML SSO)
        // Web Site Post Message with JWT Token and email
        if (message.name == "userLogin") {
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

        webView.stopLoading()
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
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("\(#function) load start")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("\(#function) load finished")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("\(#function) error is \(error)")
    }
}


