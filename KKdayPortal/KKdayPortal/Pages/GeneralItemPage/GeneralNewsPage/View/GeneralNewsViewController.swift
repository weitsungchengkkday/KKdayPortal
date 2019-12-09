//
//  GeneralNewsViewController.swift
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

final class GeneralNewsViewController: UIViewController, GeneralItemCoordinator {

     // 🏞 UI element
        lazy var imageView: UIImageView = {
            let imv = UIImageView()
            return imv
        }()
        
        lazy var wkWebView: WKWebView = {
              let wkv = WKWebView()
              return wkv
        }()

        var viewModel: GeneralNewsViewModel
        let disposeBag = DisposeBag()
        
        init(viewModel: GeneralNewsViewModel) {
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
            view.addSubview(imageView)
            view.addSubview(wkWebView)
        
            imageView.snp.makeConstraints { maker in
                maker.top.equalTo(view.snp.topMargin)
                maker.height.equalTo(view.frame.width * 2/3)
                maker.leading.equalToSuperview()
                maker.trailing.equalToSuperview()
            }
            
            wkWebView.snp.makeConstraints { maker in
                maker.top.equalTo(imageView.snp.bottom)
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
                .drive(onNext: { [weak self] title in
                    self?.title = title
                })
                .disposed(by: disposeBag)
            
            viewModel.output.showImage
                .drive(onNext: { [weak self] image in
                    self?.imageView.image = image
                })
                .disposed(by: disposeBag)
            
            viewModel.output.showText
                .drive(onNext: { [weak self] dataText in
                    self?.wkWebView.loadHTMLString(dataText, baseURL: nil)
                })
                .disposed(by: disposeBag)
        }
    }
