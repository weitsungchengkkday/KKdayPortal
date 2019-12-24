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
        webView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
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
}


