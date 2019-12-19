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
    lazy var loginStackView: UIStackView = {
        let skv = UIStackView()
        return skv
    }()
    
    lazy var accountStackView: UIStackView = {
        let skv = UIStackView()
        return skv
    }()
   
    lazy var accountLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Login"
        return lbl
    }()
    
    lazy var accountTextField: UITextField = {
        let txt = UITextField()
        txt.layer.cornerRadius = 4
        txt.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return txt
    }()
    
    lazy var passwordStackView: UIStackView = {
        let skv = UIStackView()
        return skv
    }()
    
    lazy var passwordLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Password"
        return lbl
    }()
    
    lazy var passwordTextField: UITextField = {
        let txt = UITextField()
        txt.layer.cornerRadius = 4
        txt.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return txt
    }()
    
    lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    lazy var googleSignInButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Google Sign In", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    lazy var ploneRestfulTokenButton: UIButton = {
        let btn = UIButton()
           btn.setTitle("Get Plone Restful Token", for: .normal)
           btn.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
           btn.layer.cornerRadius = 4
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

        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        view.addSubview(loginStackView)
        view.addSubview(loginButton)
        view.addSubview(googleSignInButton)
        view.addSubview(ploneRestfulTokenButton)
        
        loginStackView.axis = .vertical
        loginStackView.distribution = .fill
        loginStackView.alignment = .fill
        loginStackView.spacing = 20
        loginStackView.addArrangedSubview(accountStackView)
        loginStackView.addArrangedSubview(passwordStackView)
        
        accountStackView.axis = .vertical
        accountStackView.distribution = .fill
        accountStackView.alignment = .fill
        accountStackView.spacing = 5
        accountStackView.addArrangedSubview(accountLabel)
        accountStackView.addArrangedSubview(accountTextField)
        
        passwordStackView.axis = .vertical
        passwordStackView.distribution = .fill
        passwordStackView.alignment = .fill
        passwordStackView.spacing = 5
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordStackView.addArrangedSubview(passwordTextField)
        
        loginStackView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(50)
            maker.leading.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
        }
        
        loginButton.snp.makeConstraints { maker in
            maker.top.equalTo(loginStackView.snp.bottom).offset(10)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(120)
        }
        
        googleSignInButton.snp.makeConstraints { maker in
            maker.top.equalTo(loginButton.snp.bottom).offset(30)
            maker.centerX.equalToSuperview()
            maker.width.equalTo(120)
        }
        
        ploneRestfulTokenButton.snp.makeConstraints { maker in
            maker.top.equalTo(googleSignInButton.snp.bottom).offset(30)
            maker.centerX.equalToSuperview()
        }
        
    }
    
    // 🎬 set action
    private func setAction() {
        loginButton.addTarget(self, action: #selector(loginPlone), for: .touchUpInside)
        googleSignInButton.addTarget(self, action: #selector(signInGoogle), for: .touchUpInside)
        ploneRestfulTokenButton.addTarget(self, action: #selector(goPloneSSOPage), for: .touchUpInside)
    }
    
    @objc private func loginPlone() {
        // let account: String = accountTextField.text
        // let password: String = passwordTextField.text
        // viewModel.login(account: account, password: password)
        viewModel.login(account: "admin", password: "axl08rG1dK17")
        
        // If Login Success
        let presentViewController = MainViewController()
        presentViewController.modalPresentationStyle = .fullScreen
        present(presentViewController, animated: true, completion: nil)
    }
    
    @objc private func signInGoogle() {
        let presentViewController = SocailLoginViewController()
        present(presentViewController, animated: true, completion: nil)
    }
    
    @objc private func goPloneSSOPage() {
        let presentViewController = PloneSSOViewController()
        present(presentViewController, animated: true, completion: nil)
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        
    }
    
}
