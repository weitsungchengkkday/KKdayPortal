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
import SwiftSoup

final class GeneralRootWithLanguageViewController: UIViewController, GeneralIndexSideBarCoordinator {
    
    // 🏞 UI element
    lazy var logoImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "icKKdayLogo")
        return imv
    }()
    
    lazy var topTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 24)
        return lbl
    }()
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
        
        setupUI()
        bindViewModel()
        viewModel.getPortalData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(logoImageView)
        view.addSubview(topTitleLabel)
        view.addSubview(textView)
        
        logoImageView.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.snp.topMargin)
            maker.leading.equalToSuperview()
        }
        
        topTitleLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(logoImageView.snp.trailing)
            maker.trailing.equalToSuperview()
            maker.centerY.equalTo(logoImageView.snp.centerY)
        }
        
        textView.snp.makeConstraints { maker in
            maker.top.equalTo(logoImageView.snp.bottom)
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
                
                self?.topTitleLabel.text = content.title
                if let fixHTMLString = content.textObject?.text?.switchSelfClosingTagToNormalClosingTag(), let attributedString = fixHTMLString.htmlStringTransferToNSAttributedString() {
                    self?.textView.attributedText = attributedString
                }
                
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showGeneralItemsOfFolders
            .drive(onNext: { [weak self] generalList in
                self?.setupNavBar(lists: generalList)
            })
            .disposed(by: disposeBag)
    }
    
    // 📍 config NavBar
    private func setupNavBar(lists: [GeneralList] = []) {

        guard let nav = navigationController as? GeneralRootWithLanguageNavigationController else {
            return
        }
        if !lists.isEmpty {
            nav.indexContents = lists
        }
        
        nav.setParentLeftBarButtonItem()
    }
}

