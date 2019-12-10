//
//  GeneralLinkViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import SafariServices

final class GeneralLinkViewController: UIViewController, GeneralItemCoordinator {
    
    // 🏞 UI element
    lazy var linkButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Link", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    private let viewModel: GeneralLinkViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: GeneralLinkViewModel) {
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
        view.backgroundColor = UIColor.white
        view.addSubview(linkButton)
        linkButton.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(50)
        }
        
    }
    
    // 🎬 set action
    private func setAction() {
        
        linkButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.goWebLinkViewController()
            })
            .disposed(by: disposeBag)
    }
    
    func goWebLinkViewController() {
        
        guard let url = viewModel.generalItem?.linkObject?.url
            else {
                return
        }
        
        let safariViewController = SFSafariViewController(url: url)
        navigationController?.pushViewController(safariViewController, animated: false)
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
