//
//  GeneralFolderViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/9.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class GeneralFolderViewController: UIViewController, GeneralDetailPageCoordinator {
    
    private static var CellName: String {
        return "FolderCell"
    }
    
    // 🏞 UI element
    lazy var logoImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = PloneResourceManager.shared.currentLogoImage
        return imv
    }()
    
    lazy var topTitleLabel: GeneralItemTopTitleLabel = {
        let lbl = GeneralItemTopTitleLabel()
        return lbl
    }()
    
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        tbv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tbv.register(GeneralFolderTableViewCell.self, forCellReuseIdentifier: GeneralFolderViewController.CellName)
        tbv.tableFooterView = UIView()
        return tbv
    }()
    
    private let viewModel: GeneralFolderViewModel
    private let disposeBag = DisposeBag()
    private var isAlertNeeded: Bool = false
    
    init(viewModel: GeneralFolderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(alertIfNeeded), name: Notification.Name.alertEvent, object: nil)
        
        setupUI()
        bindViewModel()
        
        self.tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.getPortalData()
    }
    
    @objc private func alertIfNeeded(_ notification: Notification) {
        if (notification.name == Notification.Name.alertEvent) {
            MemberManager.shared.showAlertController(self, with: disposeBag)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.alertEvent, object: nil)
    }
    
    // 🎨 draw UI
    private func setupUI() {
        
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(logoImageView)
        view.addSubview(topTitleLabel)
        view.addSubview(tableView)
        
        logoImageView.snp.makeConstraints { maker in
            maker.width.equalTo(140)
            maker.height.equalTo(79)
            maker.top.equalTo(self.view.snp.topMargin)
            maker.leading.equalToSuperview()
        }
        
        topTitleLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(logoImageView.snp.trailing)
            maker.trailing.equalToSuperview().offset(-5)
            maker.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            maker.bottom.equalTo(logoImageView.snp.bottom).offset(-5)
        }
        
        tableView.snp.makeConstraints { maker in
            maker.top.equalTo(logoImageView.snp.bottom)
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
        
        viewModel.output.showTitle
            .drive(onNext: { [weak self] title in
                self?.topTitleLabel.text = title
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showGeneralItems
            .do(onNext: { [weak self] generalItems in
                if generalItems.count == 0 {
                    self?.tableView.backgroundView?.contentMode = .center
                    self?.tableView.backgroundView = NoInformationLabel()
                    
                } else {
                    self?.tableView.backgroundView = nil
                }
            })
            .drive(tableView.rx.items(cellIdentifier: GeneralFolderViewController.CellName, cellType: GeneralFolderTableViewCell.self)) { (row, generalItem, cell) in
                
                cell.typeImageView.image = generalItem.type?.image
                cell.titleLabel.text = generalItem.title
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(GeneralItem.self)
            .subscribe(onNext: { [weak self] generalItem in
                
                guard let type = generalItem.type,
                    let source = generalItem.source else {
                        return
                }
                
                switch type {
                case .root_with_language, .root, .folder, .collection, .image, .document, .news, .event, .file:
                    self?.openDetailPage(route: source, type: type)
                    
                case .link:
                    self?.openOutSiteLink(url: source)
                }
            })
            .disposed(by: disposeBag)
    }

}

extension GeneralFolderViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
