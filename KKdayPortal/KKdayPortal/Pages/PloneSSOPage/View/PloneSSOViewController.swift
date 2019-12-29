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
        
        let url = URL(string: "https://sit.eip.kkday.net/Plone")!
        webView.load(URLRequest(url: url))
        
    }
    
    // 🎨 draw UI
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        view.addSubview(webView)
        view.addSubview(loginButton)
        webView.snp.makeConstraints { maker in
            maker.trailing.leading.top.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-200)
        }
        
        loginButton.snp.makeConstraints { maker in
           maker.top.equalTo(webView.snp.bottom).offset(20)
            maker.centerX.equalToSuperview()
        }
        
    }
    
    // 🧾 localization
    private func localizedText() {}
    
    // 🎬 set action
    private func setAction() {
        loginButton.addTarget(self, action: #selector(getToken), for: .touchUpInside)
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {}
    
    
    @objc func getToken() {
      
      #if SIT_VERSION
           #if DEBUG
           let url = URL(string: "")!
           #else
           let url = URL(string: "https://sit.eip.kkday.net/Plone/@@app_login")!
           #endif
           
         #elseif PRODUCTION_VERSION
         let url = URL(string: "https://eip.kkday.net/Plone/@@app_login")!
         #else
         print("Not Implement")
         #endif
      
        webView.load(URLRequest(url: url))
    }
}

extension PloneSSOViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print(message.name)
        if (message.name == "userLogin"){
            
//            let dict = message.body as! [String : AnyObject]
//            let username = dict["username"] as! String
//            let secertToken = dict["secretToken"] as! String
        }
        
    }
}


extension PloneSSOViewController: WKNavigationDelegate {
 
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        print("⚠️")
        print(navigationResponse.response)
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        print("🔗 NavigationType: \(navigationAction.navigationType.description)")
        if navigationAction.navigationType == .linkActivated {
//            if let url = navigationAction.request.url {
//                print(url)
//                print(url.host)
//
//                if url.host == "sit.eip.kkday.net" {
//                    print("go")
//                }
//            }
            
            decisionHandler(.allow)
        } else {
            decisionHandler(.allow)
        }
        
    }
}

// HTML

//var button = document.getElementById("login-button");
//
// button.addEventListener("click", function() {
//   var message = {
//     username: "Michael Phelps",
//     secretToken: "secret"
//   };
//
//   window.webkit.messageHandlers.userLogin.postMessage(message);
// }, false);
