//
//  LanguageSettingViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/12.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit

final class LanguageSettingViewController: UIViewController {
    
    private static var CellName: String {
        return "LanguageCell"
    }
    
    // 🏞 UI element
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tbv.delegate = self
        tbv.dataSource = self
        
        tbv.register(LanguageSettingTableViewCell.self, forCellReuseIdentifier: LanguageSettingViewController.CellName)
        tbv.tableFooterView = UIView()
        return tbv
    }()
    
    private let viewModel: LanguageViewModel
    
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
        viewModel.loadLanguageItems()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.title = "Language Setting"
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    
}

extension LanguageSettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return viewModel.languageItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.languageItems[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let items = viewModel.languageItems[indexPath.section]
        let item = items.items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: LanguageSettingViewController.CellName, for: indexPath) as! LanguageSettingTableViewCell
        
        cell.titleLabel.text = item.selectedLanguage.name
        let image = item.isSelected ? #imageLiteral(resourceName: "icCheckedCircle") : #imageLiteral(resourceName: "icCircleNonchecked")
        cell.selectCellButton.setImage(image, for: .normal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let items  = viewModel.languageItems[indexPath.section].items
        items.forEach { item in
            item.isSelected = !item.isSelected
            self.dismiss(animated: true, completion: nil)
        }
        
        let currentLanguage: Language = items[indexPath.row].selectedLanguage
        
        if currentLanguage.rawValue != StorageManager.shared.load(for: .selectedLanguageKey) {
            Language.isUserSelectedLanguage = true
            LanguageManager.shared.currentLanguage = currentLanguage
            
        } else {
            print("⚠️ Save same Language")
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}

