//
//  LoginViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/21.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // 🏞 UI element
    lazy var loginTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lbl.text = "Welcome to KKPortal"
        lbl.font = UIFont.boldSystemFont(ofSize: 26)
        lbl.textAlignment = .center
        lbl.numberOfLines = 2
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    lazy var backgroundImageVeiw: UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "icLoginPageBackground")
        imv.contentMode = .scaleAspectFill
        return imv
    }()
    
    lazy var loginStackView: UIStackView = {
        let stv: UIStackView = UIStackView()
        stv.axis = .vertical
        stv.alignment = .center
        stv.distribution = .fill
        stv.spacing = 50
        return stv
    }()
    
    lazy var enterLoginInfoButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Please Enter Login Information", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    private let viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel) {
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
    }
    
    // 🎨 draw UI
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        view.addSubview(backgroundImageVeiw)
        view.addSubview(loginTitleLabel)
        view.addSubview(loginStackView)
        loginStackView.addArrangedSubview(enterLoginInfoButton)
        
        backgroundImageVeiw.snp.makeConstraints { maker in
            maker.top.equalTo(view.snp.topMargin)
            maker.bottom.equalToSuperview()
            maker.trailing.leading.equalToSuperview()
        }
        
        loginTitleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(view.snp.topMargin).offset(68)
            maker.trailing.equalToSuperview().offset(-10)
            maker.leading.equalToSuperview().offset(10)
        }
        
        loginStackView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
        }
        
        enterLoginInfoButton.snp.makeConstraints { maker in
            maker.height.equalTo(60)
            maker.width.equalToSuperview().offset(-120)
        }
        
    }
    
    // 🎬 set action
    private func setAction() {
        enterLoginInfoButton.addTarget(self, action: #selector(enterLoginInfo), for: .touchUpInside)
    }
    
    @objc private func enterLoginInfo() {
        let viewModel = LoginInfoViewModel()
        let presentViewController = LoginInfoViewController(viewModel: viewModel)
        present(presentViewController, animated: true, completion: nil)
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        
    }
    
}
