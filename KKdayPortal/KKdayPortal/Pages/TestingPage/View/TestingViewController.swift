//
//  TestingViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/20.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit

final class TestingViewController: UIViewController {
    
    private static var CellName: String {
        return "TestingCellName"
    }
    
    // private let buttonClicked = PublishSubject<Bool>()
    
//    private lazy var dataSource = {
//        return RxTableViewSectionedReloadDataSource<TestingSection> (configureCell: { [unowned self] dataSource, tableView, indexPath, item in
//
//            if let cell = tableView.dequeueReusableCell(withIdentifier: TestingViewController.CellName, for: indexPath) as? TestingTableViewCell {
//                cell.titleLabel.text = item.name
//
//                let image = item.isSelected ?  #imageLiteral(resourceName: "icCheckedCircle") : #imageLiteral(resourceName: "icCircleNonchecked")
//                cell.selectedButton.setImage(image, for: .normal)
//
               
//
//                return cell
//            }
//
//            return UITableViewCell()
//        })
//    }()
    
    // 🏞 UI element
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.delegate = self
        tbv.dataSource = self
        
        tbv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tbv.register(TestingTableViewCell.self, forCellReuseIdentifier: TestingViewController.CellName)
        tbv.tableFooterView = UIView()
        return tbv
    }()
    
    private let viewModel: TestingViewModel
    
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
        viewModel.loadTestingItems()
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
        viewModel.updateContent = { [weak self] in
            self?.tableView.reloadData()
            
        }
        
//        buttonClicked
//            .asDriver(onErrorJustReturn: false)
//            .drive(onNext: { [weak self] bool -> Void in
//
//                guard let strongSelf = self else { return }
//                strongSelf.viewModel.nextCellViewModelEvent()
//
//                if bool == false {
//                    guard let vc = self?.presentingViewController as? MainViewController else {
//                        return
//                    }
//
//                    strongSelf.dismiss(animated: true) {
//                        vc.logout()
//                    }
//                }
//
//            })
//            .disposed(by: disposeBag)
//
//        viewModel.output.showTestingItems
//            .drive(tableView.rx.items(dataSource: dataSource))
//            .disposed(by: disposeBag)
    }
}

extension TestingViewController: UITableViewDelegate, UITableViewDataSource {
    
   
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return viewModel.testingItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.testingItems[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = viewModel.testingItems[indexPath.section]
        let item = section.items[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: TestingViewController.CellName, for: indexPath) as! TestingTableViewCell
        
        
        let image = item.isSelected ?  #imageLiteral(resourceName: "icCheckedCircle") : #imageLiteral(resourceName: "icCircleNonchecked")
        cell.selectedButton.setImage(image, for: .normal)
        
        
    
//        cell.bindViewModel(cellViewModel: item, selectButtonClicked: self.buttonClicked.asObserver())
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: TestingViewController.CellName, for: indexPath) as! TestingTableViewCell
       
     //   cell.indexPath = indexPath
        
        
        cell.selectedButton.addTarget(self, action: #selector(act), for: .touchUpInside)
        
    }
    
    
    @objc private func act(sender: UIButton) {
        
        
//        let section = viewModel.testingItems[indexPath.section]
//        
//        
//        let item = section.items[indexPath.row]
       
        
    }
    
    
    
}
