//
//  LoginInfoViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/18.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift

final class LoginInfoViewController: UIViewController {
    
    // 🏞 UI element
    
    lazy var clsoeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "icCrossWhite"), for: .normal)
        return btn
    }()
    
    lazy var inputStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.distribution = .fill
        stv.alignment = .center
        stv.spacing = 30
        return stv
    }()
    
    lazy var ploneURLStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.distribution = .fill
        stv.alignment = .leading
        return stv
    }()
    
    lazy var ploneURLLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        lbl.text = "Please enter plone URL"
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var ploneURLTextField: CleanButtonTextField = {
        let txf = CleanButtonTextField()
        txf.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        txf.keyboardType = .URL
        txf.layer.cornerRadius = 12
        return txf
    }()
    
    lazy var accountStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.distribution = .fill
        stv.alignment = .leading
        return stv
    }()
    
    lazy var accountLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        lbl.text = "Please enter your account (optional)"
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var accountTextField: CleanButtonTextField = {
        let txf = CleanButtonTextField()
        txf.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        txf.keyboardType = .emailAddress
        txf.layer.cornerRadius = 12
        return txf
    }()
    
    lazy var passwordStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.distribution = .fill
        stv.alignment = .leading
        return stv
    }()
    
    lazy var passwordLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        lbl.text = "Please enter your password (optional)"
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var passwordTextFiled: TogglePasswordTextField = {
        let txf = TogglePasswordTextField()
        txf.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        txf.keyboardType = .default
        txf.layer.cornerRadius = 12
        return txf
    }()
    
    lazy var memoTextView: UITextView = {
        let txv = UITextView()
        txv.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        txv.isScrollEnabled = false
        txv.text = "If plone website support login as vister, you do not need to enter account and password"
        txv.isEditable = false
        return txv
    }()
    
    lazy var comfirmButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1), for: .normal)
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.isEnabled = false
        return btn
    }()
    
    private let viewModel: LoginInfoViewModel
    private let disposeBag = DisposeBag()
    private let loginer = Loginer()
    private var singleTapGestureRecognizer: UITapGestureRecognizer!
    
    init(viewModel: LoginInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginer.delegate = self
        
        ploneURLTextField.delegate = self
        accountTextField.delegate = self
        passwordTextFiled.delegate = self
        createGestureRecognizer()
        
        setupUI()
        setAction()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
#if TEST_VERSION
        ploneURLTextField.text = "https://eip.kkday.net/Plone"
        accountTextField.text = "will"
        passwordTextFiled.text = "12345"
        comfirmButton.isEnabled = true

#elseif SIT_VERSION
        ploneURLTextField.text = "https://sit.eip.kkday.net/Plone"
        accountTextField.text = "forwindsun"
        passwordTextFiled.text = "1234"
        comfirmButton.isEnabled = true
              
#elseif PRODUCTION_VERSION

        
#endif
        
        if let resourceType: PloneResourceType<URL> = StorageManager.shared.loadObject(for: .ploneResourceType), let user: GeneralUser = StorageManager.shared.loadObject(for: .generalUser) {
            
            switch resourceType {
            case .normal(let url):
                ploneURLTextField.text = url.absoluteString
                accountTextField.text = user.account
                comfirmButton.isEnabled = true
                
            case .kkMember:
                ploneURLTextField.text = "KKPlone"
                accountTextField.text = ""
                passwordTextFiled.text = ""
                comfirmButton.isEnabled = true
                
            case .none:
                break
            }
        } else {
            print("🎯 First time login or logout")
        }
    }
    
    // 🎨 draw UI
    private func setupUI() {
        self.view.backgroundColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        self.view.addSubview(clsoeButton)
        self.view.addSubview(inputStackView)
        
        inputStackView.addArrangedSubview(ploneURLStackView)
        ploneURLStackView.addArrangedSubview(ploneURLLabel)
        ploneURLStackView.addArrangedSubview(ploneURLTextField)
        
        inputStackView.addArrangedSubview(accountStackView)
        accountStackView.addArrangedSubview(accountLabel)
        accountStackView.addArrangedSubview(accountTextField)
       
        inputStackView.addArrangedSubview(passwordStackView)
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordStackView.addArrangedSubview(passwordTextFiled)
        
        inputStackView.addArrangedSubview(memoTextView)
        inputStackView.addArrangedSubview(comfirmButton)
        
        clsoeButton.snp.makeConstraints { maker in
            maker.width.height.equalTo(20)
            maker.top.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
        }
        
        inputStackView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
        }
        
        ploneURLLabel.snp.makeConstraints { maker in
            maker.width.equalTo(view.snp.width).offset(-120)
        }
        ploneURLTextField.snp.makeConstraints { maker in
            maker.width.equalTo(view.snp.width).offset(-100)
            maker.height.equalTo(44)
        }
        
        accountLabel.snp.makeConstraints { maker in
            maker.width.equalTo(view.snp.width).offset(-120)
        }
        accountTextField.snp.makeConstraints { maker in
            maker.width.equalTo(view.snp.width).offset(-100)
            maker.height.equalTo(44)
        }
        
        passwordLabel.snp.makeConstraints { maker in
            maker.width.equalTo(view.snp.width).offset(-120)
        }
        passwordTextFiled.snp.makeConstraints { maker in
            maker.width.equalTo(view.snp.width).offset(-100)
            maker.height.equalTo(44)
        }
        
        memoTextView.snp.makeConstraints { maker in
            maker.width.equalTo(view.snp.width).offset(-110)
        }
        
        comfirmButton.snp.makeConstraints { maker in
            maker.width.equalTo(view.snp.width).offset(-180)
            maker.height.equalTo(50)
        }
        
    }
    
    // 🧾 localization
    private func localizedText() {}
    
    private func createGestureRecognizer() {
        singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handerSingleTap))
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
    }

    @objc func handerSingleTap() {
        self.ploneURLTextField.resignFirstResponder()
        self.accountTextField.resignFirstResponder()
        self.passwordTextFiled.resignFirstResponder()
    }
    
    // 🎬 set action
    private func setAction() {
        clsoeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        comfirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func confirm() {
        login()
    }
    
    private func login() {
        
        guard let urlString = ploneURLTextField.text, !urlString.isEmpty else {
            return
        }
        
        switch urlString {
        case "KKPlone":
            print("✈️ KK Member login")
            PloneResourceManager.shared.resourceType = .kkMember
            
        default:
            print("🗺 normal login")
            guard let url = URL(string: urlString) else {
                let alertController = UIAlertController(title: "Warning", message: "Not valid URL, please check", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
                return
            }
            
            PloneResourceManager.shared.resourceType = .normal(url)
        }
        
        let resourceType = PloneResourceManager.shared.resourceType
        
        switch resourceType {
        case .kkMember:
            goPloneSSOPage()
        case .normal(url: let url):
            loginer.login(url: url, account: accountTextField.text ?? "", password: passwordTextFiled.text ?? "")
        case .none:
            print("❌, resourceType not be defined")
        }
        
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        ploneURLTextField.rx.text.subscribe(onNext: { [weak self] text in
            self?.comfirmButton.isEnabled = !(text?.isEmpty ?? true)
        })
            .disposed(by: disposeBag)
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
}

extension LoginInfoViewController: LoginDelegate {
    
    func loginSuccess(_ loginer: Loginer, generalUser user: GeneralUser) {
        
        let token = user.token
        let account = user.account
        
        debugPrint("👥 Normal Login, Get Token 💎PLONE TOKEN: \(token)")
        
        let user = GeneralUser(account: account, token: token)
        StorageManager.shared.saveObject(for: .generalUser, value: user)
        directlyGoMainViewController()
    }
    
    func loginFailed(_ loginer: Loginer, loginError error: Error) {
        
        debugPrint("🚨 Normal Login, Get Error: \(error)")
       
        let alertController = UIAlertController(title: "Warning", message: "Login Failed, Please Check your ploneURL, account, and password", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension LoginInfoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case ploneURLTextField:
            textField.resignFirstResponder()
            accountTextField.becomeFirstResponder()
        case accountTextField:
            textField.resignFirstResponder()
            passwordTextFiled.becomeFirstResponder()
        case passwordTextFiled:
            textField.resignFirstResponder()
            login()
        default:
            break
        }
        return true
    }
}