//
//  GeneralDocumentViewController.swift
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

final class GeneralDocumentViewController: UIViewController {

    // 🏞 UI element
      lazy var wkWebView: WKWebView = {
          let wkv = WKWebView()
          wkv.navigationDelegate = self
          return wkv
      }()
      
      private let viewModel: GeneralDocumentViewModel
      private let disposeBag = DisposeBag()
      
      init(viewModel: GeneralDocumentViewModel) {
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
          view.addSubview(wkWebView)
          wkWebView.snp.makeConstraints { maker in
              maker.top.equalTo(self.view.snp.topMargin)
              maker.bottom.equalTo(self.view.snp.bottomMargin)
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
              .drive(onNext: { title in
                  self.title = title
              })
              .disposed(by: disposeBag)
          
          viewModel.output.showText
              .drive(onNext: { [weak self] dataText in
                  self?.wkWebView.loadHTMLString(dataText, baseURL: nil)
              })
              .disposed(by: disposeBag)
      }
}

extension GeneralDocumentViewController: WKNavigationDelegate {
    
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
