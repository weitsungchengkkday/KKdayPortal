//
//  GeneralRootWithLanguageFoldersViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/14.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources

final class GeneralRootWithLanguageFoldersViewController: UIViewController, GeneralIndexSideBarCoordinator {
    
    private static var NormalCellName: String {
        return "GeneralRootWithLanguageFoldersNormalCell"
    }
    
    private static var HeaderCellName: String {
        return "GeneralRootWithLanguageFoldersHeaderCell"
    }
    
    // 🏞 UI element
    
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tbv.register(GeneralRootWithLanguageFoldersHeaderTableViewCell.self, forCellReuseIdentifier: GeneralRootWithLanguageFoldersViewController.HeaderCellName)
        tbv.register(GeneralRootWithLanguageFoldersNormalTableViewCell.self, forCellReuseIdentifier: GeneralRootWithLanguageFoldersViewController.NormalCellName)
        tbv.tableFooterView = UIView()
        return tbv
    }()
    
    private let viewModel: GeneralRootWithLanguageFoldersViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var dataSource = {
        return RxTableViewSectionedReloadDataSource<ContentListSection> (configureCell: { dataSource, tableView, indexPath, sectionItem in
            
            switch sectionItem {
                
            case .header(let cellViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: GeneralRootWithLanguageFoldersViewController.HeaderCellName, for: indexPath) as! GeneralRootWithLanguageFoldersHeaderTableViewCell
                cell.titleLabel.text = cellViewModel.generalItem.title
                
                let isOpen: Bool = cellViewModel.isOpen
                cell.pullDownImageView.image = isOpen ? UIImage(systemName: "arrowtriangle.up.fill") : UIImage(systemName: "arrowtriangle.down.fill")
                cell.contentView.backgroundColor = isOpen ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                return cell
                
            case .normal(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: GeneralRootWithLanguageFoldersViewController.NormalCellName, for: indexPath) as! GeneralRootWithLanguageFoldersNormalTableViewCell
                cell.titleLabel.text = viewModel.generalItem.title
                cell.typeImageView.image = viewModel.generalItem.type?.image
                
                return cell
            }
            
        })
        
    }()
    
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
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        viewModel.getPortalData()
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
            })
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                if indexPath.row == 0 {
                    self?.viewModel.switchSectionIsOpen(at: indexPath.section)
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ContentListSectionItem.self)
            .subscribe(onNext: { [weak self] sectionItem in
                
                switch sectionItem {
                case .header:
                    break
                case .normal(cellViewModel: let cellViewModel):
                    
                    guard let type = cellViewModel.generalItem.type,
                        let source = cellViewModel.generalItem.source else {
                            return
                    }
                    
                    switch type {
                    case .root_with_language, .root, .folder, .collection, .image, .document, .news, .event, .file:
                        
                        self?.goDetailIndexPage(route: source, type: type)
                        
                    case .link:
                        
                        let BPMString: String
                        
                        #if TEST_VERSION
                        BPMString = "https://sit.eip.kkday.net/Plone/zh-tw/02-all-services/bpm"
                        
                        #elseif SIT_VERSION
                        BPMString = "https://sit.eip.kkday.net/Plone/zh-tw/02-all-services/bpm"
                        
                        #elseif PRODUCTION_VERSION
                        BPMString = "https://eip.kkday.net/Plone/zh-tw/02-all-services/bpm"
                        
                        #else
                        
                        #endif
                        
                        
                        if source == URL(string: BPMString) {
                            
                            // If link is BPM open website in APP
                            self?.tabBarController?.selectedIndex = 2
                            
                        } else {
                            
                            // Others jump out from APP
                            let alertController = UIAlertController(title: "Warning", message: "Will Jump Out APP", preferredStyle: .actionSheet)
                            let confirmAlertAction = UIAlertAction(title: "Confirm", style: .default) { _ in
                                if UIApplication.shared.canOpenURL(source) {
                                    UIApplication.shared.open(source, options: [:], completionHandler: nil)
                                }
                            }
                            let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                            
                            alertController.addAction(confirmAlertAction)
                            alertController.addAction(cancelAlertAction)
                            self?.present(alertController, animated: true, completion: nil)
                        }
                    }
                    
                }
            })
            .disposed(by: disposeBag)
    }
}

extension GeneralRootWithLanguageFoldersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}


