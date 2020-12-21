//
//  GeneralRootWithLanguageFoldersViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/14.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit

final class GeneralRootWithLanguageFoldersViewController: UIViewController, GeneralDetailPageCoordinator {
    
    private static var NormalCellName: String {
        return "GeneralRootWithLanguageFoldersNormalCell"
    }
    
    private static var HeaderCellName: String {
        return "GeneralRootWithLanguageFoldersHeaderCell"
    }
    
    // 🏞 UI element
    
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.delegate = self
        tbv.dataSource = self
        
        tbv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tbv.register(GeneralRootWithLanguageFoldersHeaderTableViewCell.self, forCellReuseIdentifier: GeneralRootWithLanguageFoldersViewController.HeaderCellName)
        tbv.register(GeneralRootWithLanguageFoldersNormalTableViewCell.self, forCellReuseIdentifier: GeneralRootWithLanguageFoldersViewController.NormalCellName)
        tbv.tableFooterView = UIView()
        return tbv
    }()
    
    private let viewModel: GeneralRootWithLanguageFoldersViewModel
    
    init(viewModel: GeneralRootWithLanguageFoldersViewModel) {
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
        viewModel.loadPortalData()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
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
        viewModel.updateContent = { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.updateRootWithLanguageFolders(viewModel: weakSelf.viewModel)
        }
        
    }
    
    private func updateRootWithLanguageFolders(viewModel: GeneralRootWithLanguageFoldersViewModel) {
        
        self.tableView.reloadData()
    }

    func modifyContentListSections(contentListSections: [ContentListSection]) -> [ContentListSection] {
        
        var sections: [ContentListSection] = []
        
        for contentListSection in contentListSections {
            var section = contentListSection

            if case let .header(cellViewModel: cellViewModel) = section.items.first {
                if cellViewModel.isOpen == false {
                    section.items = [.header(cellViewModel: cellViewModel)]
                }
                sections.append(section)
            } else {
                sections.append(section)
            }
        }
        
        return sections
               
    }
 
}


extension GeneralRootWithLanguageFoldersViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        let sections = viewModel.contentListSections
        let modifySections = self.modifyContentListSections(contentListSections: sections)
        return modifySections.count
    }
   

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if viewModel.contentListSections.isEmpty {
            return 0
        }
        
        let sections = viewModel.contentListSections
        let modifySections = self.modifyContentListSections(contentListSections: sections)
        return modifySections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sections = viewModel.contentListSections
        let modifySections = self.modifyContentListSections(contentListSections: sections)
        let section = modifySections[indexPath.section]
        let item = section.items[indexPath.row]
       
        switch item {
        case .header(let cellViewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: GeneralRootWithLanguageFoldersViewController.HeaderCellName, for: indexPath) as! GeneralRootWithLanguageFoldersHeaderTableViewCell
            cell.titleLabel.text = cellViewModel.generalItem.title
            
            let isOpen: Bool = cellViewModel.isOpen
            cell.pullDownImageView.image = isOpen ? UIImage(systemName: "arrowtriangle.up.fill") ?? #imageLiteral(resourceName: "icPicture") : UIImage(systemName: "arrowtriangle.down.fill") ?? #imageLiteral(resourceName: "icPicture")
            cell.contentView.backgroundColor = isOpen ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            return cell
            
        case .normal(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: GeneralRootWithLanguageFoldersViewController.NormalCellName, for: indexPath) as! GeneralRootWithLanguageFoldersNormalTableViewCell
            cell.titleLabel.text = viewModel.generalItem.title
            cell.typeImageView.image = viewModel.generalItem.type?.image
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        if indexPath.row == 0 {
            viewModel.switchSectionIsOpen(at: indexPath.section)
        }
        
        let item = viewModel.contentListSections[indexPath.section].items[indexPath.row]
        
        switch item {
        case .header(_):
            break
            
        case .normal(let cellViewModel):
            guard let type = cellViewModel.generalItem.type,
                  let source = cellViewModel.generalItem.source else {
                return
            }
            
            self.openDetailPage(route: source, type: type)
        }
        
    }
    
}


