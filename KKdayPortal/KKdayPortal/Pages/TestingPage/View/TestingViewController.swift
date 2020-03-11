//
//  TestingViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/20.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources

final class TestingViewController: UIViewController {
    
    private static var CellName: String {
        return "TestingCellName"
    }
    
    private let buttonClicked = PublishSubject<Bool>()
    
    private lazy var dataSource = {
        return RxTableViewSectionedReloadDataSource<TestingSection> (configureCell: { [unowned self] dataSource, tableView, indexPath, item in
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: TestingViewController.CellName, for: indexPath) as? TestingTableViewCell {
                cell.titleLabel.text = item.name
                
                let image = item.isSelected ?  #imageLiteral(resourceName: "icCheckedCircle") : #imageLiteral(resourceName: "icCircleNonchecked")
                cell.selectedButton.setImage(image, for: .normal)
                
                cell.bindViewModel(cellViewModel: item, selectButtonClicked: self.buttonClicked.asObserver())
                
                return cell
            }
            
            return UITableViewCell()
        })
    }()
    
    // 🏞 UI element
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tbv.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        tbv.register(TestingTableViewCell.self, forCellReuseIdentifier: TestingViewController.CellName)
        tbv.tableFooterView = UIView()
        return tbv
    }()
    
    private let viewModel: TestingViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: TestingViewModel) {
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
        viewModel.nextCellViewModelEvent()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        self.title = "Test"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // 🎬 set action
    private func setAction() {}
    
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        
        buttonClicked
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] bool -> Void in
                
                self?.viewModel.nextCellViewModelEvent()
                if bool == false {
                    self?.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showTestingItems
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension TestingViewController: UITableViewDelegate {
    
}
