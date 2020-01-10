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
    lazy var logoImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "icKKdayLogo")
        return imv
    }()
    
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
    
    lazy var textView: UITextView = {
         let tv = UITextView()
         tv.isEditable = false
         return tv
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
        view.addSubview(logoImageView)
        view.addSubview(contactTextView)
        view.addSubview(eventTextView)
        view.addSubview(textView)
        
        logoImageView.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.snp.topMargin)
            maker.leading.equalToSuperview()
        }
        
        contactTextView.snp.makeConstraints { maker in
            maker.top.equalTo(logoImageView.snp.bottom)
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
        
        textView.snp.makeConstraints { maker in
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
            .drive(onNext: { [weak self] dataText in
                self?.textView.attributedText = dataText.htmlStringTransferToNSAttributedString()
            })
            .disposed(by: disposeBag)
    }
}

