//
//  TestingTableViewCell.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/20.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit

final class TestingTableViewCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var selectedButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "icCircleNonchecked"), for: .normal)
        return btn
    }()
    
    var selectedBtnAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(selectedButton)
        
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(10)
            maker.bottom.equalTo(-10)
            maker.left.equalToSuperview().offset(15)
        }
        
        selectedButton.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.right.equalToSuperview().offset(-17.5)
        }
        
        selectedButton.addTarget(self, action: #selector(updateSelectedBtn), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func updateSelectedBtn() {
        selectedBtnAction?()
    }

}
