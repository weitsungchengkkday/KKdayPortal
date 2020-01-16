//
//  GeneralCollectionViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/9.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class GeneralCollectionViewController: UIViewController, GeneralItemCoordinator {
    
    private static var CellName: String {
        return "CollectionCell"
    }
    
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
    
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tbv.register(GeneralCollectionTableViewCell.self, forCellReuseIdentifier: GeneralCollectionViewController.CellName)
        return tbv
    }()
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return tv
    }()
    
    private let viewModel: GeneralCollectionViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: GeneralCollectionViewModel) {
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
        
        viewModel.getPortalData()
        setupNavBar()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        view.backgroundColor = UIColor.white
        view.addSubview(logoImageView)
        view.addSubview(topTitleLabel)
        view.addSubview(tableView)
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
        
        tableView.snp.makeConstraints { maker in
            maker.top.equalTo(logoImageView.snp.bottom)
            maker.leading.equalTo(view.safeAreaLayoutGuide)
            maker.trailing.equalTo(view.safeAreaLayoutGuide)
            maker.height.equalTo(self.view.frame.width * 1)
        }
        
        textView.snp.makeConstraints { maker in
            maker.top.equalTo(tableView.snp.bottom)
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
                self?.topTitleLabel.text = title
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showGeneralItems
            .drive(tableView.rx.items(cellIdentifier: GeneralCollectionViewController.CellName, cellType: GeneralCollectionTableViewCell.self)) { (row, generalItem, cell) in
    
                cell.titleLabel.text = generalItem.title
                cell.descriptionLabel.text = generalItem.description
                
                cell.selectCellButton.rx.tap.asObservable()
                    .subscribe({ [unowned self] _ in
                        
                        guard let type = generalItem.type,
                            let source = generalItem.source else {
                            return
                        }
                        self.goDetailPage(route: source, type: type)
                    })
                    .disposed(by: cell.disposeBag)
        }
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

extension GeneralCollectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
