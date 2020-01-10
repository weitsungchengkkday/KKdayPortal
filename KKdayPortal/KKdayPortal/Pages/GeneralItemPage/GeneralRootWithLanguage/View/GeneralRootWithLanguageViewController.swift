//
//  GeneralRootWithLanguageViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/8.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import WebKit

final class GeneralRootWithLanguageViewController: UIViewController, GeneralItemCoordinator {
    
    // 🏞 UI element
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        return tv
    }()
    
    private let viewModel: GeneralRootWithLanguageViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: GeneralRootWithLanguageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupUI()
        bindViewModel()
        
        viewModel.getPortalData()
        
    }
    
    // 📍 config NavBar
    private func setupNavBar() {
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .black, scale: .large)
        let sfImage = UIImage(systemName: "text.append", withConfiguration: config)
        
        parent?.navigationItem.leftBarButtonItem = UIBarButtonItem(image: sfImage, style: .plain, target: self, action: #selector(showGeneralIndexSideBar))
    }
    
    @objc private func showGeneralIndexSideBar() {
        let generalIndexSideBarViewModel = GeneralIndexSideBarViewModel(contents: viewModel.generalItemFolders)
        let presentViewController: GeneralIndexSideBarViewController = GeneralIndexSideBarViewController(viewModel: generalIndexSideBarViewModel)
        guard let parent = parent else { return }
        parent.present(presentViewController, animated: true, completion: nil)
    }
    
    // 🎨 draw UI
    private func setupUI() {

        view.backgroundColor = UIColor.white
        view.addSubview(textView)
        textView.snp.makeConstraints { maker in
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
        
        viewModel.output.showGeneralItemsOfDocument
            .drive(onNext: { [weak self] content in
                self?.parent?.title = content.title
                self?.textView.attributedText = content.textObject?.text?.htmlStringTransferToNSAttributedString()
            })
            .disposed(by: disposeBag)
    }
}

extension GeneralRootWithLanguageViewController: WKNavigationDelegate {
    
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
