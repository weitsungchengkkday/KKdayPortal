//
//  LanguageSettingViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/12.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class LanguageSettingViewController: UIViewController {
    
    private static var CellName: String {
        return "LanguageCell"
    }
    
    // 🏞 UI element
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.register(LanguageSettingTableViewCell.self, forCellReuseIdentifier: LanguageSettingViewController.CellName)
        return tbv
    }()
    
    private let viewModel: LanguageViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: LanguageViewModel) {
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
        viewModel.nextCellViewModelsEvent()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        self.title = "Language Setting"
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    // 🎬 set action
    private func setAction() {}
    
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        
        let buttonClicked = PublishSubject<Bool>()
        
        buttonClicked
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] bool -> Void in
                self?.viewModel.nextCellViewModelsEvent()
                if bool == false {
                    self?.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showLanguageItems
            .drive(tableView.rx.items(cellIdentifier: LanguageSettingViewController.CellName, cellType: LanguageSettingTableViewCell.self)) {
                (row, cellViewModel, cell) in
                
                cell.titleLabel.text = cellViewModel.selectedLanguage.name
                let image = cellViewModel.isSelected ? #imageLiteral(resourceName: "icCheckedCircle") : #imageLiteral(resourceName: "icCircleNonchecked")
                
                cell.selectCellButton.setImage(image, for: .normal)
                
                cell.binViewModel(cellViewModel: cellViewModel, selectButtonClicked: buttonClicked.asObserver())
        }
        .disposed(by: disposeBag)
    }
}
