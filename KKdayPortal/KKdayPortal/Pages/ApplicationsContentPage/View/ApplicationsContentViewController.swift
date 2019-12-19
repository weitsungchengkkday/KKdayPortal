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
                
                guard let url = url else {
                    return
                }
                
                self?.webView.load(URLRequest(url: url))
                
            })
            .disposed(by: disposeBag)
    }
    

}
