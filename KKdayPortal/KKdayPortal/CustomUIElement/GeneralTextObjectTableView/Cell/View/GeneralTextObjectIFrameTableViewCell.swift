//
//  GeneralCollectionIFrameContentTableViewCell.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/31.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import WebKit

final class GeneralTextObjectIFrameTableViewCell: UITableViewCell {
    
    private(set) var disposeBag = DisposeBag()
    
    lazy var iframeTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return lbl
    }()
    
    lazy var iframeWKWebView: CustomWKWebView = {
        let wkv = CustomWKWebView()
        wkv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return wkv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.contentView.addSubview(iframeTitleLabel)
        self.contentView.addSubview(iframeWKWebView)
        
        iframeTitleLabel.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(24)
        }
        
        iframeWKWebView.snp.makeConstraints { maker in
            maker.top.equalTo(iframeTitleLabel.snp.bottom)
            maker.bottom.leading.trailing.equalToSuperview()
            maker.height.equalTo(400)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
}
