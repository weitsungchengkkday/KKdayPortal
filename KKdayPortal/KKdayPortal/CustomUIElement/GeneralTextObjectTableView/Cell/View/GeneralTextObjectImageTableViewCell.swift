//
//  GeneralCollectionImageContentTableViewCell.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/3.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

final class GeneralTextObjectImageTableViewCell: UITableViewCell {
    
    lazy var textObjectImageTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return lbl
    }()
    
    lazy var textObjectImageWebView: CustomWKWebView = {
        let wkv = CustomWKWebView()
        return wkv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.contentView.addSubview(textObjectImageTitleLabel)
        self.contentView.addSubview(textObjectImageWebView)
        
        textObjectImageTitleLabel.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(24)
        }
        
        textObjectImageWebView.snp.makeConstraints { maker in
            maker.top.equalTo(textObjectImageTitleLabel.snp.bottom)
            maker.bottom.leading.trailing.equalToSuperview()
            maker.height.equalTo(350)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
