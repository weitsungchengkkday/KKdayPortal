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
        lbl.text = "Welcome to KKday\nEnterprise Information Portal"
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
    
    lazy var ploneRestfulTokenButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
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
        view.addSubview(ploneRestfulTokenButton)
        
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
        
        ploneRestfulTokenButton.snp.makeConstraints { maker in
            maker.height.equalTo(60)
            maker.width.equalToSuperview().offset(-120)
            maker.bottom.equalTo(view.snp.bottomMargin).offset(-44)
            maker.centerX.equalToSuperview()
        }
    }
    
    // 🎬 set action
    private func setAction() {
        ploneRestfulTokenButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    @objc private func login() {
        
#if TEST_VERSION || SIT_VERSION
        goPloneSSOPage()
        
#elseif PRODUCTION_VERSION
        goPloneSSOPage()
        
#else
      
        
#endif
        
    }
    
    private func goPloneSSOPage() {
        let presentViewController = PloneSSOViewController()
        present(presentViewController, animated: true, completion: nil)
    }
    
    private func directlyGoMainViewController() {
        let presentViewController = MainViewController()
        presentViewController.modalPresentationStyle = .fullScreen
        present(presentViewController, animated: true, completion: nil)
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        
    }
    
}
