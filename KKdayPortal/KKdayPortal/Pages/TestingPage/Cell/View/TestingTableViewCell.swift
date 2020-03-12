//
//  TestingTableViewCell.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/20.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class TestingTableViewCell: UITableViewCell {
    
    typealias CellViewModel = TestingTableViewCellViewModel
    
    private(set) var disposeBag = DisposeBag()
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    func bindViewModel<O>(cellViewModel: CellViewModel, selectButtonClicked: O) where O: ObserverType, O.E == Bool {
        
        selectedButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                
                self?.selectedButton.setImage(#imageLiteral(resourceName: "icCheckedCircle"), for: .normal)
                
                if cellViewModel.serverType.rawValue != StorageManager.shared.load(for: .serverType) {
                    StorageManager.shared.save(for: .serverType, value: cellViewModel.serverType.rawValue)
                } else {
                    print("⚠️ Save same serverType")
                }
                
            })
            .disposed(by: disposeBag)
        
        selectedButton.rx.tap
            .map { cellViewModel.isSelected }
            .bind(to: selectButtonClicked)
            .disposed(by: disposeBag)
    }
}
