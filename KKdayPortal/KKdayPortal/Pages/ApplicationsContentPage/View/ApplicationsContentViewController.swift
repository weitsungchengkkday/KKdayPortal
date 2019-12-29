//
//  ApplicationsContentViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/18.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import WebKit

final class ApplicationsContentViewController: UIViewController {
    
    // 🏞 UI element
    lazy var webView: WKWebView = {
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
    
    private let viewModel: ApplicationsContentViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: ApplicationsContentViewModel) {
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
        viewModel.getPortalData()
    }
    
    // 🎨 draw UI
    private func setupUI() {
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
        
        viewModel.output.showTitle
            .drive(onNext: { [weak self] title in
                
                self?.title = title
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showLoadWebView
            .drive(onNext: { [weak self] url in
                
                guard var url = url else {
                    return
                }
                
                let userEmail = "william.cheng@kkday.com"
                switch url.host {
                case "sit.bpm.eip.kkday.net":
                    url = URL(string: "http://sit.bpm.eip.kkday.net/WebAgenda/sso_index1.jsp?SearchableText=\(userEmail)")!
                    
                case "bpm.eip.kkday.net":
                    url = URL(string: "http://bpm.eip.kkday.net/WebAgenda/sso_index1.jsp?SearchableText=\(userEmail)")!
                    
                default:
                    break
                }
                
                self?.webView.load(URLRequest(url: url))
                
            })
            .disposed(by: disposeBag)
    }
}

extension ApplicationsContentViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        // BPM Redirect
        if let response = navigationResponse.response as? HTTPURLResponse,
            let hearders = response.allHeaderFields as? [String : Any],
            let redirectURL = hearders["kkday_bpm_sso_url"] as? String {
            
            print("RedirectURL is: \(redirectURL)")
            let url = URL(string: redirectURL)!
            webView.load(URLRequest(url: url))
        }
        
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
            ()
        }
        
        print(error)
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


