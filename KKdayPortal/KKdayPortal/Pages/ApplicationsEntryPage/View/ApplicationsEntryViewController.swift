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
    lazy var collectionView: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        flowLayout.itemSize = CGSize(width: 120, height: 160)
        
        let clv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        clv.delegate = self
        clv.dataSource = self
        
        clv.register(ApplicationsEntryCollectionViewCell.self, forCellWithReuseIdentifier: ApplicationsEntryViewController.CellName)
        clv.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        
        return clv
    }()
        
        
//    lazy var tableView: UITableView = {
//        let tbv = UITableView()
//
//        tbv.delegate = self
//        tbv.dataSource = self
//
//        tbv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        tbv.register(ApplicationsEntryTableViewCell.self, forCellReuseIdentifier: ApplicationsEntryViewController.CellName)
//        tbv.tableFooterView = UIView()
//        return tbv
//    }()
    
    private let viewModel = ApplicationsEntryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadPortalData()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        self.title = "Service Links"
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide)
            maker.leading.equalTo(view.safeAreaLayoutGuide)
            maker.trailing.equalTo(view.safeAreaLayoutGuide)
            maker.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
//        view.addSubview(tableView)
//
//        tableView.snp.makeConstraints { maker in
//            maker.top.equalTo(view.safeAreaLayoutGuide)
//            maker.leading.equalTo(view.safeAreaLayoutGuide)
//            maker.trailing.equalTo(view.safeAreaLayoutGuide)
//            maker.bottom.equalTo(view.safeAreaLayoutGuide)
//        }
   
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        viewModel.updateContent = { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.updateApplicationEntry(viewModel: weakSelf.viewModel)
        }
    }
    
    private func updateApplicationEntry(viewModel: ApplicationsEntryViewModel) {
    //    tableView.reloadData()
    }
}

extension ApplicationsEntryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return viewModel.linkObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = viewModel.linkObjects[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ApplicationsEntryViewController.CellName, for: indexPath) as! ApplicationsEntryCollectionViewCell
        cell.titleLabel.text = item.name
     //   cell.applicationImageView.image = item.applicationImage
        
        return cell
    }
    
    
}
//
//extension ApplicationsEntryViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return viewModel.linkObjects.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let item = viewModel.linkObjects[indexPath.row]
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: ApplicationsEntryViewController.CellName, for: indexPath) as! ApplicationsEntryTableViewCell
//        cell.titleLabel.text = item.name
//        cell.descriptionLabel.text = item.description
//
//        return cell
//    }
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let linkObject = viewModel.linkObjects[indexPath.row]
//        goDetailPageInWebView(url: linkObject.url)
//    }
//
//    private func goDetailPageInWebView(url: URL) {
//
//        let pushViewController = ApplicationsContentViewController(viewModel: ApplicationsContentViewModel(source: url))
//        navigationController?.pushViewController(pushViewController, animated: false)
//    }
//
//}
