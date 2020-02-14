//
//  GeneralIndexSideBarHeaderTableViewCell.swift
//  KKdayPortal-Sit
//
//  Created by WEI-TSUNG CHENG on 2020/1/17.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class GeneralRootWithLanguageFoldersHeaderTableViewCell: UITableViewCell {
    
    private(set) var disposeBag = DisposeBag()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        lbl.font = UIFont.systemFont(ofSize: 18)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var pullDownImageView: UIImageView = {
        let imv = UIImageView()
        return imv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(pullDownImageView)
        
        titleLabel.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.left.equalToSuperview().offset(15)
        }
        
        pullDownImageView.snp.makeConstraints { maker in
            maker.height.width.equalTo(24)
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview().offset(-17.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
}
