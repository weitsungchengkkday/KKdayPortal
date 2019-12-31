//
//  LoadingViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/31.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LoadingViewController: UIViewController {

    // 🏞 UI element
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
  
    lazy var stackView: UIStackView = {
        let stv = UIStackView()
        stv.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        return stv
    }()
    
    lazy var imageView: UIImageView = {
        let imv = UIImageView()
        imv.contentMode = .scaleAspectFit
        return imv
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let viewModel: LoadingViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: LoadingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setAction()
        bindViewModel()
        viewModel.loadLoading()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        view.addSubview(containerView)
        containerView.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        
        containerView.snp.makeConstraints { maker in
            maker.width.equalTo(176)
            maker.height.equalTo(176)
            maker.centerX.centerY.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
            maker.width.equalTo(146)
            maker.height.equalTo(146)
        }

    }
    
    // 🧾 localization
    private func localizedText() {}
    
    // 🎬 set action
    private func setAction() {}
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        
        viewModel.output.showLoadingImage
            .drive(onNext: { [weak self] image in
                self?.imageView.image = image
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showLoadingTitle
            .drive(onNext: { [weak self] (text, isHidden) in
                self?.titleLabel.text = text
                self?.titleLabel.isHidden = isHidden
            })
            .disposed(by: disposeBag)
    }

    
}
