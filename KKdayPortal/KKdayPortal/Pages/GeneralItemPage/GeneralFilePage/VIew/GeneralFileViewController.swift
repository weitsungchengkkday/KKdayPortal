//
//  GeneralFileViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class GeneralFileViewController: UIViewController {
    
    // 🏞 UI element
    
    private let viewModel: GeneralFileViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: GeneralFileViewModel) {
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

