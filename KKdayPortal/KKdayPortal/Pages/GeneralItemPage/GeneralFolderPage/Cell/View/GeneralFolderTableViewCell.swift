//
//  GeneralFolderTableViewCell.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/9.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class GeneralFolderTableViewCell: UITableViewCell {
    
    private(set) var disposeBag = DisposeBag()
    
    lazy var typeImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "icPicture")
        return imv
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var rightArrowImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "icRightArrowGrey")
        return imv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(typeImageView)
        self.contentView.addSubview(rightArrowImageView)
        
        typeImageView.snp.makeConstraints { maker in
            maker.height.width.equalTo(24)
            maker.centerY.equalToSuperview()
            maker.left.equalToSuperview().offset(15)
        }
        
        titleLabel.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.right.equalTo(rightArrowImageView.snp.left).offset(-15)
            maker.left.equalTo(typeImageView.snp.right).offset(15)
        }
        
        rightArrowImageView.snp.makeConstraints { maker in
            maker.height.width.equalTo(16)
            maker.centerY.equalToSuperview()
            maker.right.equalToSuperview().offset(-17.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
}
