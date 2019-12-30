//
//  ApplicationsEntryViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/18.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ApplicationsEntryViewController: UIViewController, GeneralItemCoordinator {
    
    private static var ItemName: String {
        return "EntryItem"
    }
    
    // 🏞 UI element
    lazy var collectionView: UICollectionView = {
        let clv: UICollectionView
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 160, height: 240)
        layout.minimumLineSpacing = CGFloat(integerLiteral: 10)
        layout.minimumInteritemSpacing = CGFloat(integerLiteral: 10)
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        clv = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height),
                               collectionViewLayout: layout)
        clv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        clv.register(ApplicationsEntryCollectionViewCell.self, forCellWithReuseIdentifier: ApplicationsEntryViewController.ItemName)
        
        return clv
    }()
    
    private lazy var loadingActivityIndicatorContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
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
    
    private let viewModel: ApplicationsEntryViewModel = {
        
        #if SIT_VERSION
        #if DEBUG
        let applicationSourceURL = URL(string: "http://localhost:8080/pikaPika/application-items")!
        #else
        let applicationSourceURL = URL(string: "https://sit.eip.kkday.net/Plone/zh-tw/02-all-services")!
        #endif
        
        #elseif PRODUCTION_VERSION
        let applicationSourceURL = URL(string: "https://eip.kkday.net/Plone/zh-tw/02-all-services")!
        #else
        print("Not Implement")
        #endif
        
        return ApplicationsEntryViewModel(source: applicationSourceURL)
    }()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setAction()
        bindViewModel()
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.getPortalData()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(collectionView)
        view.addSubview(loadingActivityIndicatorContainerView)
        loadingActivityIndicatorContainerView.addSubview(loadingActivityIndicatorView)
        
        collectionView.snp.makeConstraints { maker in
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
        
        viewModel.output.showGeneralItems
            .drive(collectionView.rx.items(cellIdentifier: ApplicationsEntryViewController.ItemName, cellType: ApplicationsEntryCollectionViewCell.self)) { (row, generalItem, cell) in
                cell.titleLabel.text = generalItem.title
                cell.descriptionLabel.text = generalItem.description
                
        }
        .disposed(by: disposeBag)
        
        viewModel.output.showTitle
            .drive(onNext: { [weak self] text in
                self?.title = text
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showIsLoading
            .map { !$0 }
            .drive(loadingActivityIndicatorContainerView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.output.showIsLoading
            .drive(loadingActivityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}

extension ApplicationsEntryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let generalList = viewModel.generalItem as? GeneralList,
            let items = generalList.items,
            let source = items[indexPath.row].source,
            let type = items[indexPath.row].type else {
                return
        }
        
        goDetailPageInWebView(route: source, type: type)
    }
    
}
