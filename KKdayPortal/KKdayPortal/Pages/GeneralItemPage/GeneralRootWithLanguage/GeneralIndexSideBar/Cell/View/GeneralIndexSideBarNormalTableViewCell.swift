//
//  GeneralIndexSideBarNormalTableViewCell.swift
//  KKdayPortal-Sit
//
//  Created by WEI-TSUNG CHENG on 2020/1/9.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class GeneralIndexSideBarNormalTableViewCell: UITableViewCell {
    
    private(set) var disposeBag = DisposeBag()
    
    lazy var typeImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "icPicture")
        return imv
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(typeImageView)
        
        typeImageView.snp.makeConstraints { maker in
            maker.height.width.equalTo(24)
            maker.centerY.equalToSuperview()
            maker.left.equalToSuperview().offset(50)
        }
        
        titleLabel.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.right.equalToSuperview().offset(-15)
            maker.left.equalTo(typeImageView.snp.right).offset(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
}
