//
//  PloneSSOViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/19.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit
import WebKit
import DolphinHTTP

final class PloneSSOViewController: UIViewController {
    
    // 🏞 UI element
    lazy var SSOwebView: WKWebView = {
        let contentController = WKUserContentController()
        contentController.add(self, name: "userLogin")
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let wkv = WKWebView(frame: self.view.bounds, configuration: config)
        wkv.navigationDelegate = self
        return wkv
    }()
    
    private let viewModel: PloneSSOViewModel
    
    init(viewModel: PloneSSOViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setAction()
        bindViewModel()
        
        guard let config: PortalConfig = StorageManager.shared.loadObject(for: .portalConfig), let loginURL = URL(string: config.data.login.url) else {
             return
        }
        
        self.SSOwebView.load(URLRequest(url: loginURL))
    }
    
    // 🎨 draw UI
    private func setupUI() {
        view.addSubview(SSOwebView)
        
        SSOwebView.snp.makeConstraints { maker in
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
                
                debugPrint("👥 SSO Login, Get Token 💎PLONE TOKEN: \(token) 👦🏼SignInUser: \(account)")
                let user = GeneralUser(account: account, token: token)
                StorageManager.shared.saveObject(for: .generalUser, value: user)
                
                goMainViewController()
                
            } else {
                debugPrint("🚨 Get Token form message body failed, message is \(message.body)")
                WebCacheCleaner.clean()
                dismiss(animated: true, completion: nil)
            }
        } else {
            debugPrint("🚨 Get Token form message failed, message name \(message.name)")
            WebCacheCleaner.clean()
            dismiss(animated: true, completion: nil)
        }
        
        SSOwebView.stopLoading()
    }
    
}

extension PloneSSOViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        print("📮 Navigation Response: \(navigationResponse.response)")
        guard let response = navigationResponse.response as? HTTPURLResponse else {
            return
        }
        
        let statusCode = response.statusCode
        guard statusCode >= 200 && statusCode <= 300 else {
            
            let alertController =  UIAlertController(title: "general_warning".localize("警告", defaultValue: "Warning"), message: "plone_sso_alert_message".localize("請使用有效的 email account", defaultValue: "Please use valid email account"), preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "general_ok".localize("好", defaultValue: "OK"), style: .default) { [weak self] _ in
                WebCacheCleaner.clean()
                self?.dismiss(animated: true, completion: nil)
            }
            
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let navigationType = navigationAction.navigationType
        print("🔗 Navigation Type: \(navigationType)")
        
        if let url = navigationAction.request.url {
            print("🌐 Navigation URL: \(url)")
        }
        
        decisionHandler(.allow)
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
