//
//  PloneFolderViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/25.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PloneFolderViewController: UIViewController, PloneCoordinator {
    
    static let CellName = "FolderCell"
    
    // 🏞 UI element
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.register(PloneFolderTableViewCell.self, forCellReuseIdentifier: PloneFolderViewController.CellName)
        return tbv
    }()
    
    var viewModel: PloneFolderViewModel
    let disposeBag = DisposeBag()
    
    init(viewModel: PloneFolderViewModel) {
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
        
        self.tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.getPloneData()
        
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
        
        viewModel.output.showTitle
            .drive(onNext: { [weak self] title in
                self?.title = title
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showPloneItems
            .drive(tableView.rx.items(cellIdentifier: PloneFolderViewController.CellName, cellType: PloneFolderTableViewCell.self)) { (row, ploneItem, cell) in
            
                cell.titleLabel.text = ploneItem.title
                cell.descriptionLabel.text = ploneItem.description
                
                cell.selectCellButton.rx.tap.asObservable()
                    .subscribe({ [unowned self] _ in
                        
                        self.goDetailPage(route: ploneItem.atID, type: ploneItem.atType)
                    })
                    .disposed(by: cell.disposeBag)
        }
        .disposed(by: disposeBag)
    }
}

extension PloneFolderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
