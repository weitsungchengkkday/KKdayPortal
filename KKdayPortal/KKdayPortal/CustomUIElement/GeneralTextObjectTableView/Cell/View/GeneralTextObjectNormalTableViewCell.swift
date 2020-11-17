//
//  GeneralCollectionNormalContentTableViewCell.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/31.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit

final class GeneralTextObjectNormalTableViewCell: UITableViewCell {
    
    lazy var normalContentTextView: UITextView = {
        let txv = UITextView()
        txv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        txv.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        txv.isEditable = false
        txv.isScrollEnabled = false
        return txv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.contentView.addSubview(normalContentTextView)
        normalContentTextView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
