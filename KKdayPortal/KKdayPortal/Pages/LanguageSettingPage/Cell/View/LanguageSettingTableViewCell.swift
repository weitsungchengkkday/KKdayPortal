//
//  LanguageSettingTableViewCell.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/12.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class LanguageSettingTableViewCell: UITableViewCell {
    
    typealias CellViewModel = LanguageSettingTableViewCellViewModel
    
    private(set) var disposeBag = DisposeBag()
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
    
         self.contentView.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9568627451, alpha: 1)
         self.contentView.addSubview(containerView)
         self.containerView.addSubview(topView)
         self.topView.addSubview(titleLabel)
         self.topView.addSubview(selectCellButton)
         self.containerView.addSubview(descriptionLabel)
         
         
         containerView.snp.makeConstraints { make in
             make.width.equalToSuperview()
             make.edges.equalToSuperview()
         }
         
         topView.snp.makeConstraints { make in
             make.height.equalTo(36)
             make.top.left.right.equalToSuperview()
         }
         
         titleLabel.snp.makeConstraints { make in
             make.centerY.equalToSuperview()
             make.left.equalToSuperview().offset(15)
         }
         
         selectCellButton.snp.makeConstraints { make in
             make.centerY.equalToSuperview()
             make.right.equalTo(self.containerView).offset(-17.5)
         }
         
         descriptionLabel.snp.makeConstraints { make in
             make.top.equalTo(self.topView.snp.bottom).offset(10)
             make.left.equalToSuperview().offset(15)
             make.right.equalToSuperview().offset(-15)
             make.bottom.equalToSuperview().offset(-20)
         }
     }
    
    required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    override func prepareForReuse() {
        super.prepareForReuse()
         disposeBag = DisposeBag()
     }
    
    func binViewModel<O>(cellViewModel: CellViewModel, selectButtonClicked: O) where O: ObserverType, O.E == Bool {
        
        
        selectCellButton.rx.tap
            .subscribe(onNext: { [weak self] _ in

                self?.selectCellButton.setImage(#imageLiteral(resourceName: "icCheckedCircle"), for: .normal)
                
                LanguageManager.shared.currentLanguage = cellViewModel.selectedLanguage
            })
            .disposed(by: disposeBag)
        
        selectCellButton.rx.tap
            .map{ cellViewModel.isSelected }
            .bind(to: selectButtonClicked)
            .disposed(by: disposeBag)
    }
}
