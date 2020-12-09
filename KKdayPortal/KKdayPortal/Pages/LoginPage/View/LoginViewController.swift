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
        btn.setTitle("Enter Login Information", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.titleEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 0)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    lazy var instructionButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("""
        Usage Notice (check format,
        if you already have Plone website)
        """, for: .normal)
        btn.titleLabel?.numberOfLines = 0
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        btn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        return btn
    }()
    
    
    lazy var ploneIntroButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("""
        How to build your own Plone Website
        (open official docuement,
        if you don't have Plone website)
        """, for: .normal)
        btn.titleLabel?.numberOfLines = 0
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        btn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
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
        loginStackView.addArrangedSubview(instructionButton)
        loginStackView.addArrangedSubview(ploneIntroButton)
        
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
            maker.width.equalTo(view.snp.width).offset(-100)
        }
        
    }
    
    // 🎬 set action
    private func setAction() {
        enterLoginInfoButton.addTarget(self, action: #selector(goLoginInfoPage), for: .touchUpInside)
        instructionButton.addTarget(self, action: #selector(goIntroductionPage), for: .touchUpInside)
        ploneIntroButton.addTarget(self, action: #selector(goPloneIntroductionPage), for: .touchUpInside)
    }
    
    @objc private func goLoginInfoPage() {
        let viewModel = SigninInfoViewModel()
        let presentViewController = SigninInfoViewController(viewModel: viewModel)
        present(presentViewController, animated: true, completion: nil)
    }
    
    @objc private func goIntroductionPage() {
        let presentViewController = IntroductionViewController()
        present(presentViewController, animated: true, completion: nil)
    }
    
    @objc private func goPloneIntroductionPage() {
        let presentViewController = PloneIntroductionViewController()
        present(presentViewController, animated: true, completion: nil)
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        
    }
    
}
