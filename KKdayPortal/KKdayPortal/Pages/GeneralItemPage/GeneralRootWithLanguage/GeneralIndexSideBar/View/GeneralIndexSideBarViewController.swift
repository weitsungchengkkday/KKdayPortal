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
    
    private static var NormalCellName: String {
        return "IndexSideBarNormalCell"
    }
    
    private static var HeaderCellName: String {
        return "IndexSideBarHeaderCell"
    }
    
    // 🏞 UI element
    lazy var topView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lbl.font = UIFont.boldSystemFont(ofSize: 24)
        lbl.numberOfLines = 1
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .center
        lbl.text = "Table of Content"
        return lbl
    }()

    lazy var closeButton: UIButton = {
        let btn = UIButton()
        let image = UIImage(systemName: "multiply", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40, weight: .medium))
        btn.setImage(image, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tbv.register(GeneralIndexSideBarHeaderTableViewCell.self, forCellReuseIdentifier: GeneralIndexSideBarViewController.HeaderCellName)
        tbv.register(GeneralIndexSideBarNormalTableViewCell.self, forCellReuseIdentifier: GeneralIndexSideBarViewController.NormalCellName)
        return tbv
    }()
    
    private let viewModel: GeneralIndexSideBarViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var dataSource = {
        return RxTableViewSectionedReloadDataSource<ContentListSection> (configureCell: { dataSource, tableView, indexPath, sectionItem in
            
            switch sectionItem {
                
            case .header(let cellViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: GeneralIndexSideBarViewController.HeaderCellName, for: indexPath) as! GeneralIndexSideBarHeaderTableViewCell
                cell.titleLabel.text = cellViewModel.generalItem.title
                
                let isOpen: Bool = cellViewModel.isOpen
                cell.pullDownImageView.image = isOpen ? UIImage(systemName: "arrowtriangle.up.fill") : UIImage(systemName: "arrowtriangle.down.fill")
                cell.contentView.backgroundColor = isOpen ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                return cell
                
            case .normal(let viewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: GeneralIndexSideBarViewController.NormalCellName, for: indexPath) as! GeneralIndexSideBarNormalTableViewCell
                cell.titleLabel.text = viewModel.generalItem.title
                cell.typeImageView.image = viewModel.generalItem.type?.image
                
                return cell
            }
            
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
        setAction()
        bindViewModel()
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        viewModel.loadPortalContent()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        view.addSubview(topView)
        topView.addSubview(titleLabel)
        topView.addSubview(closeButton)
        view.addSubview(tableView)
        
        topView.snp.makeConstraints { maker in
           maker.top.equalTo(view.safeAreaLayoutGuide)
           maker.leading.trailing.equalToSuperview()
           maker.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().offset(50)
            maker.trailing.equalToSuperview().offset(-50)
        }
        
        closeButton.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.height.width.equalTo(40)
            maker.trailing.equalToSuperview().offset(-5)
        }
        
        tableView.snp.makeConstraints { maker in
            maker.top.equalTo(topView.snp.bottom)
            maker.leading.equalTo(view.safeAreaLayoutGuide)
            maker.trailing.equalTo(view.safeAreaLayoutGuide)
            maker.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // 🎬 set action
    private func setAction() {
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
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
                    
                    guard let tabVC = self?.presentingViewController as? UITabBarController,
                        let rootNav = tabVC.selectedViewController as? UINavigationController else {
                            return
                    }
                    
                    guard let homeVC = rootNav.viewControllers[0] as? HomeViewController,
                        let nav = homeVC.children.first as? GeneralRootWithLanguageNavigationController,
                        let vc = nav.viewControllers.first as? GeneralRootWithLanguageViewController else {
                            return
                    }
                    
                    switch type {
                    case .root_with_language, .root, .folder, .collection, .image, .document, .news, .event, .file:
                        vc.goDetailIndexPage(route: source, type: type)
                        self?.dismiss(animated: true, completion: nil)
                        
                    case .link:
                        if source == URL(string: "https://sit.eip.kkday.net/Plone/zh-tw/02-all-services/bpm") {
                            
                            // If link is BPM open website in APP
                            guard let currentViewController = Utilities.currentViewController as? GeneralIndexSideBarViewController else {
                                return
                            }
                            guard let tab = currentViewController.presentingViewController as? MainViewController else {
                                return
                            }
                            
                            tab.selectedIndex = 0
                            self?.dismiss(animated: true, completion: nil)
                            
                        } else {
                            
                            // Others jump out from APP
                            let alertController = UIAlertController(title: "Warning", message: "Will Jump Out APP", preferredStyle: .actionSheet)
                            let confirmAlertAction = UIAlertAction(title: "Confirm", style: .default) { _ in
                                if UIApplication.shared.canOpenURL(source) {
                                    UIApplication.shared.open(source, options: [:], completionHandler: nil)
                                    self?.dismiss(animated: true, completion: nil)
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


extension GeneralIndexSideBarViewController {
    
    func openApplication() {
        
    }
    
    
}

extension GeneralIndexSideBarViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}


