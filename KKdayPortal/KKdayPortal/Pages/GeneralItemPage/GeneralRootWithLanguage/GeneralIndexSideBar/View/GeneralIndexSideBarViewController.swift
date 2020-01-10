//
//  GeneralIndexSideBarViewController.swift
//  KKdayPortal-Sit
//
//  Created by WEI-TSUNG CHENG on 2020/1/9.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class GeneralIndexSideBarViewController: UIViewController {
    
    private static var CellName: String {
        return "IndexSideBarCell"
    }
    
    // 🏞 UI element
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.register(GeneralIndexSideBarTableViewCell.self, forCellReuseIdentifier: GeneralIndexSideBarViewController.CellName)
        return tbv
    }()
    
    private let viewModel: GeneralIndexSideBarViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: GeneralIndexSideBarViewModel) {
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
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.loadPortalContent()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide)
            maker.leading.equalTo(view.safeAreaLayoutGuide)
            maker.trailing.equalTo(view.safeAreaLayoutGuide)
            maker.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // 🎬 set action
    private func setAction() {
        
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        
        viewModel.output.showGeneralItems
            .drive(tableView.rx.items(cellIdentifier: GeneralIndexSideBarViewController.CellName, cellType: GeneralIndexSideBarTableViewCell.self)) { (row, generalItem, cell) in
                
                cell.titleLabel.text = generalItem.title
                cell.descriptionLabel.text = generalItem.description
                
                cell.selectCellButton.rx.tap.asObservable()
                    .subscribe({ [unowned self] _ in
                        
                        guard let type = generalItem.type,
                            let source = generalItem.source else {
                                return
                        }
                        
                        guard let presentingViewController = self.presentingViewController as? UITabBarController,
                            let nav = presentingViewController.selectedViewController as? UINavigationController else {
                                return
                        }
                        
                        for vc in nav.viewControllers {
                            if let vc = vc as? HomeViewController {
                                vc.goDetailPage(route: source, type: type)
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    })
                    .disposed(by: cell.disposeBag)
        }
        .disposed(by: disposeBag)
    }
}

extension GeneralIndexSideBarViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


