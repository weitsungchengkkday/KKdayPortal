//
//  GeneralEventViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import WebKit

final class GeneralEventViewController: UIViewController {

      // 🏞 UI element
        lazy var contactTextView: UITextView = {
            let txf = UITextView()
            txf.isEditable = false
            txf.isSelectable = false
            return txf
        }()
        
        lazy var eventTextView: UITextView = {
            let txf = UITextView()
            txf.isEditable = false
            txf.isSelectable = false
            return txf
        }()
        
        lazy var wkWebView: WKWebView = {
            let wkv = WKWebView()
            wkv.navigationDelegate = self
            return wkv
        }()
       
        private let viewModel: GeneralEventViewModel
        private let disposeBag = DisposeBag()
        
        init(viewModel: GeneralEventViewModel) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            bindViewModel()
            viewModel.getPortalData()
            
        }
        
        // 🎨 draw UI
        private func setupUI() {
            view.backgroundColor = UIColor.white
            view.addSubview(contactTextView)
            view.addSubview(eventTextView)
            view.addSubview(wkWebView)
            
            contactTextView.snp.makeConstraints { maker in
                maker.top.equalTo(view.snp.topMargin)
                maker.height.equalTo(60)
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
            }
            
            eventTextView.snp.makeConstraints { maker in
                maker.top.equalTo(contactTextView.snp.bottom)
                maker.height.equalTo(100)
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
            }
            
            wkWebView.snp.makeConstraints { maker in
                maker.top.equalTo(eventTextView.snp.bottom)
                maker.bottom.equalTo(view.snp.bottomMargin)
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
            }
        }
        
        // 🎬 set action
        private func setAction() {
            
        }
        
        // ⛓ bind viewModel
        private func bindViewModel() {
            
            viewModel.output.showTitle
                .drive(onNext: { [weak self] title in
                    self?.title = title
                })
                .disposed(by: disposeBag)
            
            viewModel.output.showContact
                .drive(onNext: { [weak self] contact in
                    self?.contactTextView.text = contact
                })
                .disposed(by: disposeBag)
            
            viewModel.output.showEvent
                .drive(onNext: { [weak self] event in
                    self?.eventTextView.text = event
                })
                .disposed(by: disposeBag)
            
            viewModel.output.showText
                .drive(onNext: { [weak self] text in
                    self?.wkWebView.loadHTMLString(text, baseURL: nil)
                })
                .disposed(by: disposeBag)
        }
    }

extension GeneralEventViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        print("🔗 NavigationType: \(navigationAction.navigationType.description)")
        if navigationAction.navigationType == .linkActivated {
            
            if let url = navigationAction.request.url {
                UIApplication.shared.open(url)
            }
            decisionHandler(.cancel)

        } else {
            decisionHandler(.allow)
        }
        
    }
}
