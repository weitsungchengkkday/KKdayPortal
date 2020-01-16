//
//  GeneralImageViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class GeneralImageViewController: UIViewController {
    
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
        imv.image = #imageLiteral(resourceName: "icPicture")
        imv.contentMode = .scaleAspectFit
        return imv
    }()
    
    private let viewModel: GeneralImageViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: GeneralImageViewModel) {
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
        self.view.addSubview(imageView)
        
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
    }
}
