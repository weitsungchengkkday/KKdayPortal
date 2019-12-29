//
//  ApplicationsEntryCollectionViewCell.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/18.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class ApplicationsEntryCollectionViewCell: UICollectionViewCell {
    
    private(set) var disposeBag = DisposeBag()
    
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var logoImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = UIImage(systemName: "globe")
        return imv
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let ind = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        return ind
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.contentView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        self.contentView.addSubview(containerView)
        self.containerView.addSubview(logoImageView)
        self.containerView.addSubview(indicatorView)
        self.containerView.addSubview(titleLabel)
        self.containerView.addSubview(descriptionLabel)
        
        containerView.snp.makeConstraints { maker in
            maker.width.equalToSuperview()
            maker.edges.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(80)
        }
        
        indicatorView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(logoImageView.snp.bottom)
            maker.centerX.equalToSuperview()
            maker.height.equalTo(20)
        }
        
        descriptionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom)
            maker.centerX.equalToSuperview()
            maker.height.equalTo(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
}
