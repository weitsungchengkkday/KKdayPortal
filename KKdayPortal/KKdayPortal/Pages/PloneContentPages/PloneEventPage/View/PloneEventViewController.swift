//
//  PloneEventViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/30.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import WebKit

class PloneEventViewController: UIViewController, PloneCoordinator {
    
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
        return wkv
    }()
   
    var viewModel: PloneEventViewModel
    let disposeBag = DisposeBag()
    
    init(viewModel: PloneEventViewModel) {
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
        viewModel.getPloneData()
        
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
        
        viewModel.output.showDataText
            .drive(onNext: { [weak self] dataText in
                self?.wkWebView.loadHTMLString(dataText, baseURL: nil)
            })
            .disposed(by: disposeBag)
    }
}
