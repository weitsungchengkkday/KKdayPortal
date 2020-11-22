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
        
        cell.titleLabel.text = item.name
        let image = item.isSelected ?  #imageLiteral(resourceName: "icCheckedCircle") : #imageLiteral(resourceName: "icCircleNonchecked")
        cell.selectedButton.setImage(image, for: .normal)
        
        cell.selectedBtnAction = { [unowned self] in
            
            let items = viewModel.testingItems[indexPath.section].items
            
            items.forEach { item in
                let image = !item.isSelected ?  #imageLiteral(resourceName: "icCheckedCircle") : #imageLiteral(resourceName: "icCircleNonchecked")
                item.isSelected = !item.isSelected
                cell.selectedButton.setImage(image, for: .normal)
            }
            
            tableView.reloadData()
            
            // Change Storage server
            let currentServerType: ServerTypes = items[indexPath.row].serverType
            
            if currentServerType != StorageManager.shared.load(for: .serverType) {
                StorageManager.shared.save(for: .serverType, value: currentServerType.rawValue)
            } else {
                print("⚠️ Save same serverType")
            }
            
            // Logout after change server
            guard let vc = self.presentingViewController as? MainViewController else {
                return
            }
            
            self.dismiss(animated: true) {
                vc.logout()
            }
        }
        
        return cell
    }
    
}
