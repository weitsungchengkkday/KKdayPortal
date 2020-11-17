//
//  GeneralCollectionViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/9.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit

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
        tbv.delegate = self
        tbv.dataSource = self
        
        tbv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tbv.register(GeneralCollectionTableViewCell.self, forCellReuseIdentifier: GeneralCollectionViewController.CellName)
        tbv.tableFooterView = UIView()
        return tbv
    }()
    
    lazy var generalTextObjectTableView: UITableView = {
        let tbv = UITableView()
        tbv.delegate = self
        tbv.dataSource = self
        
        tbv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tbv.register(GeneralTextObjectNormalTableViewCell.self, forCellReuseIdentifier: GeneralCollectionViewController.GeneralTextObjectCellName.normal)
        tbv.register(GeneralTextObjectIFrameTableViewCell.self, forCellReuseIdentifier: GeneralCollectionViewController.GeneralTextObjectCellName.iframe)
        tbv.register(GeneralTextObjectImageTableViewCell.self, forCellReuseIdentifier: GeneralCollectionViewController.GeneralTextObjectCellName.image)
        tbv.tableFooterView = UIView()
        return tbv
    }()
    
    private let viewModel: GeneralCollectionViewModel
    
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
        viewModel.loadPortalData()
    }
    
    @objc private func alertIfNeeded(_ notification: Notification) {
        if (notification.name == Notification.Name.alertEvent) {
//            MemberManager.shared.showAlertController(self, with: disposeBag)
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
        
        viewModel.updateContent = { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.updateCollection(viewModel: weakSelf.viewModel)
        }
    }
    
    private func updateCollection(viewModel: GeneralCollectionViewModel) {
        self.topTitleLabel.text = viewModel.collectionTitle
        
        self.descriptionTextView.text = viewModel.collectionDescription
        self.descriptionTextView.isHidden = viewModel.collectionDescription.isEmpty
    
        self.itemsTableView.reloadData()
        self.itemsTableView.isHidden = viewModel.generalItemsSubject.isEmpty
    
        self.generalTextObjectTableView.reloadData()
        
    }
}


extension GeneralCollectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         
        if tableView == generalTextObjectTableView {
            return UITableView.automaticDimension
            
        } else if tableView == itemsTableView {
            return 60
            
        } else {
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == generalTextObjectTableView {
            return viewModel.collectionGeneralTextObjectItems[section].items.count
            
        } else if tableView == itemsTableView {
            return viewModel.generalItemsSubject.count
            
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == generalTextObjectTableView {
            let section = viewModel.collectionGeneralTextObjectItems[indexPath.section]
            let items = section.items[indexPath.row]
            
            switch items {
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
            
        } else if tableView == itemsTableView {
            
            let item = viewModel.generalItemsSubject[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: GeneralCollectionViewController.CellName, for: indexPath) as! GeneralCollectionTableViewCell
            
            cell.titleLabel.text = item.title
            cell.descriptionLabel.text = item.description
            cell.selectCellButton.tag = indexPath.row
            cell.selectCellButton.addTarget(self, action: #selector (self.openPage), for: .touchUpInside)
            
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    }
    
    
    @objc func openPage(sender: UIButton) {
        let row = sender.tag
        
        let item = viewModel.generalItemsSubject[row]
        
        if let type = item.type,
           let source = item.source {
            openDetailPage(route: source, type: type)
        }
    }
    
}


