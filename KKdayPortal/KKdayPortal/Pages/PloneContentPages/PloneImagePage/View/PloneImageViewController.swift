//
//  PloneImageViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/30.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PloneImageViewController: UIViewController, PloneCoordinator {
    
    // 🏞 UI element
    lazy var imageView: UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "icPicture")
        imv.contentMode = .scaleAspectFit
        return imv
    }()
    
    var viewModel: PloneImageViewModel
    let disposeBag = DisposeBag()
    
    init(viewModel: PloneImageViewModel) {
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
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { maker in
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
            .drive(onNext: { [weak self] title in
                self?.title = title
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showImage
            .drive(onNext: { [weak self] image in
                self?.imageView.image = image
            })
            .disposed(by: disposeBag)
    }
}
