//
//  PloneFileViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/30.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PloneFileViewController: UIViewController , PloneCoordinator {
    
    // 🏞 UI element
    
    var viewModel: PloneFileViewModel
    let disposeBag = DisposeBag()
    
    init(viewModel: PloneFileViewModel) {
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
        
        let url = URL(string: "http://localhost:8080/pikaPika/movietheater/kkorganization/@@download/file")!
        viewModel.downloadFile(fileURL: url)
    }
    
    // 🎨 draw UI
    private func setupUI() {
        view.backgroundColor = UIColor.white
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
    }
}

