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
import RxDataSources

final class GeneralIndexSideBarViewController: UIViewController {
    
    private static var CellName: String {
        return "IndexSideBarCell"
    }
    
    // 🏞 UI element
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tbv.register(GeneralIndexSideBarTableViewCell.self, forCellReuseIdentifier: GeneralIndexSideBarViewController.CellName)
        return tbv
    }()
    
    private let viewModel: GeneralIndexSideBarViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var dataSource = {
        return RxTableViewSectionedReloadDataSource<ContentListSection> (configureCell: { dataSource, tableView, indexPath, item in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: GeneralIndexSideBarViewController.CellName, for: indexPath) as! GeneralIndexSideBarTableViewCell
            cell.titleLabel.text = item.generalItem.title
            cell.typeImageView.image = item.generalItem.type?.image
            
            return cell
        })
        
    }()
    
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
        
        viewModel.output.showGeneralItems
            .map({ contentListSections -> [ContentListSection] in
                
                var sections: [ContentListSection] = []
                
                for contentListSection in contentListSections {
                    var section = contentListSection
                    
                    if section.isOpen == false {
                        section.items = []
                        sections.append(section)
                    } else {
                        sections.append(section)
                    }
                }
                
                return sections
            })
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(GeneralIndexSideBarTableViewCellViewModel.self).subscribe(onNext: { [weak self] cellViewModel in
            
            guard let type = cellViewModel.generalItem.type,
                let source = cellViewModel.generalItem.source else {
                    return
            }
            
            guard let tabVC = self?.presentingViewController as? UITabBarController,
                let rootNav = tabVC.selectedViewController as? UINavigationController else {
                    return
            }
            
            guard let homeVC = rootNav.viewControllers[0] as? HomeViewController,
                let nav = homeVC.children.first as? GeneralRootWithLanguageNavigationController,
                let vc = nav.viewControllers.first as? GeneralRootWithLanguageViewController else {
                    return
            }
            
            vc.goDetailIndexPage(route: source, type: type)
            self?.dismiss(animated: true, completion: nil)
            
        })
            .disposed(by: disposeBag)
        
    }
}

extension GeneralIndexSideBarViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerTitle = viewModel.contentListSections[section].header
        
        let btn = UIButton()
        btn.tag = section
        btn.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        btn.setTitle(headerTitle, for: .normal)
        btn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        btn.addTarget(self, action: #selector(hideSectionRows), for: .touchUpInside)
        
        return btn
    }
    
    @objc func hideSectionRows(_ btn: UIButton) {
        let section = btn.tag
        viewModel.switchSectionIsOpen(at: section)
    }
}


