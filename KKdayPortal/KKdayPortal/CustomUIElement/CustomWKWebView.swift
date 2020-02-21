//
//  CustomWKWebView.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/13.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import WebKit

final class CustomWKWebView: WKWebView {
    
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
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        self.navigationDelegate = self
        
    self.addSubview(loadingActivityIndicatorContainerView)
        loadingActivityIndicatorContainerView.addSubview(loadingActivityIndicatorView)
        
        loadingActivityIndicatorContainerView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
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
    
    private func startLoadingAnimation() {
        loadingActivityIndicatorContainerView.isHidden = false
        loadingActivityIndicatorView.startAnimating()
    }
    
    private func stopLoadingAnimation() {
        loadingActivityIndicatorContainerView.isHidden = true
        loadingActivityIndicatorView.stopAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CustomWKWebView: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        startLoadingAnimation()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        stopLoadingAnimation()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        stopLoadingAnimation()
    }
    
}


