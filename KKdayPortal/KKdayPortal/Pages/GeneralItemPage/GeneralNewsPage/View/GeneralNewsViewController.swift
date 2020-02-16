//
//  GeneralNewsViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import WebKit
import RxDataSources

final class GeneralNewsViewController: UIViewController {
    
    // generalTextObject cell
    struct GeneralTextObjectCellName {
        static let normal: String = "GeneralTextObjectNormalCell"
        static let iframe: String = "GeneralTextObjectIframeCell"
        static let image: String = "GeneralTextObjectImageIframeCell"
    }
    
    // 🏞 UI element
    lazy var logoImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "icKKdayLogo")
        return imv
    }()
    
    lazy var topTitleLabel: GeneralItemTopTitleLabel = {
        let lbl = GeneralItemTopTitleLabel()
        return lbl
    }()
    
    lazy var descriptionTextView: GeneralItemDescriptionTextView = {
        let txv = GeneralItemDescriptionTextView()
        return txv
    }()
    
    lazy var stackView: UIStackView = {
        let stv = UIStackView()
        stv.distribution = .fill
        stv.axis = .vertical
        return stv
    }()
    
    lazy var imageView: UIImageView = {
        let imv = UIImageView()
        return imv
    }()
    
    lazy var generalTextObjectTableView: UITableView = {
        let tbv = UITableView()
        tbv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tbv.register(GeneralTextObjectNormalTableViewCell.self, forCellReuseIdentifier: GeneralNewsViewController.GeneralTextObjectCellName.normal)
        tbv.register(GeneralTextObjectIFrameTableViewCell.self, forCellReuseIdentifier: GeneralNewsViewController.GeneralTextObjectCellName.iframe)
        tbv.register(GeneralTextObjectImageTableViewCell.self, forCellReuseIdentifier: GeneralNewsViewController.GeneralTextObjectCellName.image)
        tbv.tableFooterView = UIView()
        return tbv
    }()
    
    private let viewModel: GeneralNewsViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var generalTextObjectDataSource = {
        return RxTableViewSectionedReloadDataSource<GeneralTextObjectSection>(configureCell: { [weak self] dataSource, tableView, indexPath, sectionItem in
            
            switch sectionItem {
            case .normal(let cellViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: GeneralNewsViewController.GeneralTextObjectCellName.normal, for: indexPath) as! GeneralTextObjectNormalTableViewCell
                
                cell.normalContentTextView.attributedText = cellViewModel.text.htmlStringTransferToNSAttributedString()
                return cell
                
            case .iframe(let cellViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: GeneralNewsViewController.GeneralTextObjectCellName.iframe, for: indexPath) as! GeneralTextObjectIFrameTableViewCell
                cell.iframeTitleLabel.text = cellViewModel.title
                cell.iframeWKWebView.load(URLRequest(url: cellViewModel.url))
                return cell
                
            case .image(let cellViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: GeneralNewsViewController.GeneralTextObjectCellName.image, for: indexPath) as! GeneralTextObjectImageTableViewCell
                cell.textObjectImageTitleLabel.text = cellViewModel.title
                cell.textObjectImageWebView.load(URLRequest(url:cellViewModel.url))
                return cell
            }
        })
    }()
    
    init(viewModel: GeneralNewsViewModel) {
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
        view.addSubview(descriptionTextView)
        view.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(generalTextObjectTableView)
        
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
        
        descriptionTextView.snp.makeConstraints { maker in
            maker.top.equalTo(logoImageView.snp.bottom)
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(50)
        }
        
        stackView.snp.makeConstraints { maker in
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
        
        viewModel.output.showImage
            .drive(onNext: { [weak self] image in
                self?.imageView.image = image
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showGeneralTextObjectItems
            .do(onNext: { [weak self] generalTextObjectSections in
                self?.generalTextObjectTableView.isHidden = generalTextObjectSections.isEmpty
            }) .drive(generalTextObjectTableView.rx.items(dataSource: generalTextObjectDataSource))
            .disposed(by: disposeBag)
    }
}
