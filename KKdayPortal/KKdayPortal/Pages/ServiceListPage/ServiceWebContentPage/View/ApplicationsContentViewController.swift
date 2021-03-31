//
//  ApplicationsContentViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/18.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

final class ApplicationsContentViewController: UIViewController {
    
    // 🏞 UI element
    private lazy var webView: WKWebView = {
        let wkv = WKWebView()
        wkv.navigationDelegate = self
        return wkv
    }()
    
    private lazy var loadingActivityIndicatorContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    private lazy var loadingActivityIndicatorView: UIActivityIndicatorView = {
        let idv = UIActivityIndicatorView(style: .large)
        idv.color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return idv
    }()
    
    private let viewModel: ServiceWebContentViewModel
    
    init(viewModel: ServiceWebContentViewModel) {
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
        loadWebsite()
    }
        
    // 🎨 draw UI
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(webView)
        webView.addSubview(loadingActivityIndicatorContainerView)
        loadingActivityIndicatorContainerView.addSubview(loadingActivityIndicatorView)
        
        webView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        loadingActivityIndicatorContainerView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.width.equalTo(65)
            maker.height.equalTo(65)
        }
        
        loadingActivityIndicatorView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.width.equalTo(60)
            maker.height.equalTo(00)
        }
    }
    
    // 🧾 localization
    private func localizedText() {}
    
    // 🎬 set action
    private func setAction() {}
    
    // ⛓ bind viewModel
    private func bindViewModel() {
    }
    
    private func loadWebsite() {
        let url = viewModel.source
        self.webView.load(URLRequest(url: url))
    }
}

extension ApplicationsContentViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("\(#function) load start")
        showActivityInicator(true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("\(#function) load finished")
        showActivityInicator(false)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        let error = error as NSError
        switch error.code {
        case -1001:
            print("\(#function) error is 'TimeOut'")
        case -1003:
            print("\(#function) error is 'Server cannot be found'")
        case -1009:
            print("\(#function) error is 'Offline'")
        case -1100:
            print("\(#function) error is 'URL not be found on server'")
        default:
            print(error)
        }
        
        showActivityInicator(false)
    }
    
    private func showActivityInicator(_ bool: Bool) {
        if bool {
            loadingActivityIndicatorView.startAnimating()
            loadingActivityIndicatorContainerView.isHidden = false
        } else {
            loadingActivityIndicatorView.stopAnimating()
            loadingActivityIndicatorContainerView.isHidden = true
        }
    }
}


