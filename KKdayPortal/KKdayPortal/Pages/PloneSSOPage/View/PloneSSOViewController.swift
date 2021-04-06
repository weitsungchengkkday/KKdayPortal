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
        loadPortalServices()
        
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
    
    private func loadPortalServices() {

#if SIT
    loadPortalServicesRemote()
   
#elseif PRODUCTION
    loadPortalServicesRemote()

#elseif OPEN
    loadPortalServicesLocal()

#else
    print("❗️target not exist")

#endif
        
    }
    
    private func loadPortalServicesRemote() {
        
        viewModel.getPortalServicesRemote { errors in
            
            if errors.isEmpty {
                
                let service: PortalService? = StorageManager.shared.loadObject(for: .plonePortalService)
                
                guard let element = service?.elements.filter({ $0.name == "Website URL"}).first else {
                    print("❌ Can't Get Plone URL")
                    return
                }
                
                let urlString = element.content + "/Plone/@@app_login"
                
                let url = URL(string: urlString)!
                
                DispatchQueue.main.async {
                    self.SSOwebView.load(URLRequest(url: url))
                }
                
            } else {
                let alertController = UIAlertController(title: "Warning", message: "Get Portal Service Failed", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                
                print("❌ Get Portal Services Error \(errors)")
            }
        }
        
    }
    
    private func loadPortalServicesLocal() {
       
        viewModel.getPortalServicesLocal { errors in
            
            if errors.isEmpty {
                
                print(self.viewModel.portalservices)
                
                let service: PortalService? = StorageManager.shared.loadObject(for: .plonePortalService)
                
                guard let element = service?.elements.filter({ $0.name == "Website URL"}).first else {
                    print("❌ Can't Get Plone URL")
                    return
                }
                
                let urlString = element.content + "/Plone/@@app_login"
                
                let url = URL(string: urlString)!
                
                DispatchQueue.main.async {
                    self.SSOwebView.load(URLRequest(url: url))
                }
                
            } else {
                let alertController = UIAlertController(title: "Warning", message: "Get Portal Service Failed", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
                    self.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                
                print("❌ Get Portal Services Error \(errors)")
            }
        }
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
                
                debugPrint("👥 SSO Login, Get Token 💎PLONE TOKEN: \(token)")
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
            
            let alertController =  UIAlertController(title: "Warning", message: "Please use valid email account", preferredStyle: .alert)
            
            let alertAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
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
