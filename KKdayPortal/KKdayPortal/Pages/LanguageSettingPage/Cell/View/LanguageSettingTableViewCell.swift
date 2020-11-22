//
//  LanguageSettingTableViewCell.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/12.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit

final class LanguageSettingTableViewCell: UITableViewCell {
    
    typealias CellViewModel = LanguageSettingTableViewCellViewModel
    
    lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var selectCellButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "icCircleNonchecked"), for: .normal)
        return btn
    }()
    
    lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    var selectedBtnAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
    
         self.contentView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
         self.contentView.addSubview(containerView)
         self.containerView.addSubview(topView)
         self.topView.addSubview(titleLabel)
         self.topView.addSubview(selectCellButton)
         self.containerView.addSubview(descriptionLabel)
         
         containerView.snp.makeConstraints { maker in
             maker.width.equalToSuperview()
             maker.edges.equalToSuperview()
         }
         
         topView.snp.makeConstraints { maker in
             maker.height.equalTo(36)
             maker.top.left.right.equalToSuperview()
         }
         
         titleLabel.snp.makeConstraints { maker in
             maker.centerY.equalToSuperview()
             maker.left.equalToSuperview().offset(15)
         }
         
         selectCellButton.snp.makeConstraints { maker in
             maker.centerY.equalToSuperview()
             maker.right.equalTo(self.containerView).offset(-17.5)
         }
         
         descriptionLabel.snp.makeConstraints { maker in
             maker.top.equalTo(self.topView.snp.bottom).offset(10)
             maker.left.equalToSuperview().offset(15)
             maker.right.equalToSuperview().offset(-15)
             maker.bottom.equalToSuperview().offset(-20)
         }
        
        selectCellButton.addTarget(self, action: #selector(updateSelectedBtn), for: .touchUpInside)
     }
    
    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    @objc func updateSelectedBtn() {
        selectedBtnAction?()
    }
}
