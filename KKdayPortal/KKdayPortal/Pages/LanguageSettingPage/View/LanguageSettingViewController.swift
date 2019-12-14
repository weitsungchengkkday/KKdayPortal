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
import RxDataSources

final class LanguageSettingViewController: UIViewController {
    
    private static var CellName: String {
        return "LanguageCell"
    }

    let buttonClicked = PublishSubject<Bool>()
    
    lazy var dataSource = {
        return RxTableViewSectionedReloadDataSource<LanguageSection> (
            configureCell: { [unowned self] dataSource, tableView, indexPath, item in
                
                
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: LanguageSettingViewController.CellName, for: indexPath) as? LanguageSettingTableViewCell {
                    
                    cell.titleLabel.text = item.selectedLanguage.name
                    let image = item.isSelected ? #imageLiteral(resourceName: "icCheckedCircle") : #imageLiteral(resourceName: "icCircleNonchecked")
                    cell.selectCellButton.setImage(image, for: .normal)
                    cell.bindViewModel(cellViewModel: item, selectButtonClicked: self.buttonClicked.asObserver())
                    return cell
                }
                
                return UITableViewCell()
        },
            titleForHeaderInSection: { dataSource, section in
                return dataSource.sectionModels[section].header
        })
    }()
    
    // 🏞 UI element
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
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
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension LanguageSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}


