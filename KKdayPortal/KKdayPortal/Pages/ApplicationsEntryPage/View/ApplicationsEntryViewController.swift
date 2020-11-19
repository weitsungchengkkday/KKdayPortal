//
//  ApplicationsEntryViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/18.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit

final class ApplicationsEntryViewController: UIViewController {
    
    private static var CellName: String {
        return "EntryCell"
    }
    
    // 🏞 UI element
    lazy var tableView: UITableView = {
        let tbv = UITableView()
        
        tbv.delegate = self
        tbv.dataSource = self
        
        tbv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        tbv.register(ApplicationsEntryTableViewCell.self, forCellReuseIdentifier: ApplicationsEntryViewController.CellName)
        tbv.tableFooterView = UIView()
        return tbv 
    }()
    
    private lazy var loadingActivityIndicatorContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    private lazy var loadingActivityIndicatorView: UIActivityIndicatorView = {
        let idv = UIActivityIndicatorView(style: .large)
        idv.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return idv
    }()
    
    private let viewModel = ApplicationsEntryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setAction()
        bindViewModel()
        
        viewModel.loadPortalData()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        self.title = "Service Links"
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(tableView)
        view.addSubview(loadingActivityIndicatorContainerView)
        loadingActivityIndicatorContainerView.addSubview(loadingActivityIndicatorView)
        
        tableView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide)
            maker.leading.equalTo(view.safeAreaLayoutGuide)
            maker.trailing.equalTo(view.safeAreaLayoutGuide)
            maker.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        loadingActivityIndicatorContainerView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.width.equalTo(65)
            maker.height.equalTo(65)
        }
        
        loadingActivityIndicatorView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.width.equalTo(60)
            maker.height.equalTo(00)
        }
        
    }
    
    // 🧾 localization
    private func localizedText() {}
    
    // 🎬 set action
    private func setAction() {}
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        
    }
//        viewModel.output.showGeneralItemsURL
//            .drive(tableView.rx.items(cellIdentifier: ApplicationsEntryViewController.CellName, cellType: ApplicationsEntryTableViewCell.self)) { (row, url, cell) in
//
//                cell.titleLabel.text = "BPM"
//                cell.descriptionLabel.text = "簽核系統"
//        }
//        .disposed(by: disposeBag)
//
//        viewModel.output.showIsLoading
//            .map { !$0 }
//            .drive(loadingActivityIndicatorContainerView.rx.isHidden)
//            .disposed(by: disposeBag)
//
//        viewModel.output.showIsLoading
//            .drive(loadingActivityIndicatorView.rx.isAnimating)
//            .disposed(by: disposeBag)
//    }
}

extension ApplicationsEntryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewMode.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let URLs = viewModel.generalItemsURL
        let route = URLs[indexPath.row]
        goDetailPageInWebView(route: route)
    }
    
    private func goDetailPageInWebView(route: URL) {
        let pushViewController = ApplicationsContentViewController(viewModel: ApplicationsContentViewModel(source: route))
        navigationController?.pushViewController(pushViewController, animated: false)
    }
    
    
}
