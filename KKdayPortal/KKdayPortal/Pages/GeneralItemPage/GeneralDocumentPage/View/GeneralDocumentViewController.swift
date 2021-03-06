//
//  GeneralDocumentViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

final class GeneralDocumentViewController: UIViewController {
    
    // generalTextObject cell
    struct GeneralTextObjectCellName {
        static let normal: String = "GeneralTextObjectNormalCell"
        static let iframe: String = "GeneralTextObjectIframeCell"
        static let image: String = "GeneralTextObjectImageIframeCell"
    }
    
    // 🏞 UI element
    lazy var logoImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = UserResourceManager.shared.currentLogoImage
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
    
    lazy var generalTextObjectTableView: UITableView = {
       
        let tbv = UITableView()
        tbv.delegate = self
        tbv.dataSource = self
        
        tbv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tbv.register(GeneralTextObjectNormalTableViewCell.self, forCellReuseIdentifier: GeneralDocumentViewController.GeneralTextObjectCellName.normal)
        tbv.register(GeneralTextObjectIFrameTableViewCell.self, forCellReuseIdentifier: GeneralDocumentViewController.GeneralTextObjectCellName.iframe)
        tbv.register(GeneralTextObjectImageTableViewCell.self, forCellReuseIdentifier: GeneralDocumentViewController.GeneralTextObjectCellName.image)
        tbv.tableFooterView = UIView()
        return tbv
    }()
    
    private let viewModel: GeneralDocumentViewModel
    
    init(viewModel: GeneralDocumentViewModel) {
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
        view.addSubview(generalTextObjectTableView)
        
        logoImageView.snp.makeConstraints { maker in
            maker.width.equalTo(140)
            maker.height.equalTo(79)
            maker.top.equalTo(self.view.snp.topMargin)
            maker.leading.equalToSuperview()
        }
        
        topTitleLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(logoImageView.snp.trailing)
            maker.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            maker.bottom.equalTo(logoImageView.snp.bottom).offset(-5)
        }
        
        topStackView.snp.makeConstraints { maker in
            maker.top.equalTo(logoImageView.snp.bottom)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        
        generalTextObjectTableView.snp.makeConstraints { maker in
            maker.top.equalTo(descriptionTextView.snp.bottom)
            maker.bottom.equalTo(view.safeAreaLayoutGuide)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }
    
    // 🎬 set action
    private func setAction() {
        
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        viewModel.upateContent = { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.updateDocument(viewModel: weakSelf.viewModel)
        }
    }
    
    private func updateDocument(viewModel: GeneralDocumentViewModel) {
        self.topTitleLabel.text = viewModel.documentTitle
        
        let text = viewModel.documentDescription
        self.descriptionTextView.isHidden = text.isEmpty
        self.descriptionTextView.text = text
       
        self.generalTextObjectTableView.reloadData()
    }
    
}


extension GeneralDocumentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.documentGeneralTextObjectItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if viewModel.documentGeneralTextObjectItems.isEmpty {
            return 0
        }
        
        return self.viewModel.documentGeneralTextObjectItems[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = viewModel.documentGeneralTextObjectItems[indexPath.section]
        let item = section.items[indexPath.row]
        
        switch item {
        case .normal(let cellViewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: GeneralDocumentViewController.GeneralTextObjectCellName.normal, for: indexPath) as! GeneralTextObjectNormalTableViewCell
            
            cell.normalContentTextView.attributedText = cellViewModel.text.htmlStringTransferToNSAttributedString()
            return cell
            
        case .iframe(let cellViewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: GeneralDocumentViewController.GeneralTextObjectCellName.iframe, for: indexPath) as! GeneralTextObjectIFrameTableViewCell
            cell.iframeTitleLabel.text = cellViewModel.title
            cell.iframeWKWebView.load(URLRequest(url: cellViewModel.url))
            return cell
            
        case .image(let cellViewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: GeneralDocumentViewController.GeneralTextObjectCellName.image, for: indexPath) as! GeneralTextObjectImageTableViewCell
            cell.textObjectImageTitleLabel.text = cellViewModel.title
            cell.textObjectImageWebView.load(URLRequest(url:cellViewModel.url))
            return cell
        }
        
    }
    
}
