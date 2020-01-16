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

final class GeneralNewsViewController: UIViewController {
    
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
    
    lazy var imageView: UIImageView = {
        let imv = UIImageView()
        return imv
    }()
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return tv
    }()
    
    private let viewModel: GeneralNewsViewModel
    private let disposeBag = DisposeBag()
    
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
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(logoImageView)
        view.addSubview(topTitleLabel)
        view.addSubview(imageView)
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
        
        imageView.snp.makeConstraints { maker in
            maker.top.equalTo(logoImageView.snp.bottom)
            maker.height.equalTo(view.frame.width * 2/3)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        
        textView.snp.makeConstraints { maker in
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
                self?.topTitleLabel.text = title
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showImage
            .drive(onNext: { [weak self] image in
                self?.imageView.image = image
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showText
            .drive(onNext: { [weak self] dataText in
                self?.textView.attributedText = dataText.htmlStringTransferToNSAttributedString()
            })
            .disposed(by: disposeBag)
    }
}

