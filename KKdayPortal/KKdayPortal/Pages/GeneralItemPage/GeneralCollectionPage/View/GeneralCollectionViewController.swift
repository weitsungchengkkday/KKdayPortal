//
//  GeneralCollectionViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/9.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import RxDataSources

class GeneralCollectionViewController: UIViewController, GeneralDetailPageCoordinator {
    
    // items cell
    private static var CellName: String {
        return "CollectionCell"
    }
    
    // generalTextObject cell
    struct GeneralTextObjectCellName {
        static let normal: String = "GeneralTextObjectNormalCell"
        static let iframe: String = "GeneralTextObjectIframeCell"
        static let image: String = "GeneralTextObjectImageIframeCell"
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
    
    lazy var topStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.distribution = .fill
        return stv
    }()
    
    lazy var descriptionTextView: GeneralItemDescriptionTextView = {
        let txv = GeneralItemDescriptionTextView()
        return txv
    }()
    
    lazy var bottomStackView: UIStackView = {
        let stv = UIStackView()
        stv.distribution = .fill
        stv.axis = .vertical
        return stv
    }()
    
    lazy var itemsTableView: UITableView = {
        let tbv = UITableView()
        tbv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tbv.register(GeneralCollectionTableViewCell.self, forCellReuseIdentifier: GeneralCollectionViewController.CellName)
        tbv.tableFooterView = UIView()
        return tbv
    }()
    
    lazy var generalTextObjectTableView: UITableView = {
        let tbv = UITableView()
        tbv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tbv.register(GeneralTextObjectNormalTableViewCell.self, forCellReuseIdentifier: GeneralCollectionViewController.GeneralTextObjectCellName.normal)
        tbv.register(GeneralTextObjectIFrameTableViewCell.self, forCellReuseIdentifier: GeneralCollectionViewController.GeneralTextObjectCellName.iframe)
        tbv.register(GeneralTextObjectImageTableViewCell.self, forCellReuseIdentifier: GeneralCollectionViewController.GeneralTextObjectCellName.image)
        tbv.tableFooterView = UIView()
        return tbv
    }()
    
    private let viewModel: GeneralCollectionViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var generalTextObjectDataSource = {
        return RxTableViewSectionedReloadDataSource<GeneralTextObjectSection>(configureCell: { [weak self] dataSource, tableView, indexPath, sectionItem in
            
            switch sectionItem {
            case .normal(let cellViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: GeneralCollectionViewController.GeneralTextObjectCellName.normal, for: indexPath) as! GeneralTextObjectNormalTableViewCell
                
                cell.normalContentTextView.attributedText = cellViewModel.text.htmlStringTransferToNSAttributedString()
                return cell
                
            case .iframe(let cellViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: GeneralCollectionViewController.GeneralTextObjectCellName.iframe, for: indexPath) as! GeneralTextObjectIFrameTableViewCell
                cell.iframeTitleLabel.text = cellViewModel.title
                cell.iframeWKWebView.load(URLRequest(url: cellViewModel.url))
                return cell
                
            case .image(let cellViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: GeneralCollectionViewController.GeneralTextObjectCellName.image, for: indexPath) as! GeneralTextObjectImageTableViewCell
                cell.textObjectImageTitleLabel.text = cellViewModel.title
                cell.textObjectImageWebView.load(URLRequest(url:cellViewModel.url))
                return cell
            }
        })
    }()
    
    init(viewModel: GeneralCollectionViewModel) {
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
        itemsTableView.rx
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
        view.addSubview(topStackView)
        topStackView.addArrangedSubview(descriptionTextView)
        view.addSubview(bottomStackView)
        bottomStackView.addArrangedSubview(itemsTableView)
        bottomStackView.addArrangedSubview(generalTextObjectTableView)
        
        logoImageView.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.snp.topMargin)
            maker.width.equalTo(140)
            maker.height.equalTo(79)
            maker.leading.equalToSuperview()
        }
        
        topTitleLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(logoImageView.snp.trailing)
            maker.trailing.equalToSuperview().offset(-5)
            maker.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            maker.bottom.equalTo(logoImageView.snp.bottom).offset(-5)
        }
        
        topStackView.snp.makeConstraints { maker in
            maker.top.equalTo(logoImageView.snp.bottom)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        
        bottomStackView.snp.makeConstraints { maker in
            maker.top.equalTo(descriptionTextView.snp.bottom)
            maker.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
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
        
        viewModel.output.showDescription
            .do(onNext: { [weak self] text in
                self?.descriptionTextView.isHidden = text.isEmpty
            })
            .drive(onNext: { [weak self] text in
                self?.descriptionTextView.text = text
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showGeneralItems
            .do(onNext: { [weak self] generalItems in
                self?.itemsTableView.isHidden = generalItems.isEmpty
            })
            .drive(itemsTableView.rx.items(cellIdentifier: GeneralCollectionViewController.CellName, cellType: GeneralCollectionTableViewCell.self)) { (row, generalItem, cell) in
                
                cell.titleLabel.text = generalItem.title
                cell.descriptionLabel.text = generalItem.description
                
                cell.selectCellButton.rx.tap.asObservable()
                    .subscribe({ [unowned self] _ in
                        
                        guard let type = generalItem.type,
                            let source = generalItem.source else {
                                return
                        }
                        switch type {
                        case .root_with_language, .root, .folder, .collection, .image, .document, .news, .event, .file:
                            self.openDetailPage(route: source, type: type)
                            
                        case .link:
                            self.openOutSiteLink(url: source)
                        }
                    })
                    .disposed(by: cell.disposeBag)
        }
        .disposed(by: disposeBag)
        
        viewModel.output.showGeneralTextObjectItems
            .do(onNext: { [weak self] generalTextObjectSections in
                self?.generalTextObjectTableView.isHidden = generalTextObjectSections.isEmpty
            })
            .drive(generalTextObjectTableView.rx.items(dataSource: generalTextObjectDataSource))
            .disposed(by: disposeBag)
    }
}

extension GeneralCollectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
