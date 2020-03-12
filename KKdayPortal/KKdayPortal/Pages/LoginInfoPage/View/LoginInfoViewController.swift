//
//  LoginInfoViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/18.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift

final class LoginInfoViewController: UIViewController, Keyboarder {
    
    // 🏞 UI element
    
    lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "icCrossWhite"), for: .normal)
        return btn
    }()
    
    lazy var scrollView: UIScrollView? = {
        let srv = UIScrollView()
        srv.keyboardDismissMode = .onDrag
        return srv
    }()
    
    lazy var container: UIView = {
        let view = UIView()
        return view
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
        lbl.text = "Please enter your plone website URL"
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var ploneURLTextField: CleanButtonTextField = {
        let txf = CleanButtonTextField()
        txf.placeholder = "https://"
        txf.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        txf.keyboardType = .URL
        txf.layer.cornerRadius = 12
        txf.returnKeyType = .next
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
        txf.keyboardType = .default
        txf.layer.cornerRadius = 12
        txf.returnKeyType = .next
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
        txf.returnKeyType = .go
        return txf
    }()
    
    lazy var memoTextView: UITextView = {
        let txv = UITextView()
        txv.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        txv.isScrollEnabled = false
        txv.text = "If plone website support login as visitor, you do not need to enter account and password"
        txv.isEditable = false
        return txv
    }()
    
    lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1), for: .normal)
        btn.setTitle("Login", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.isEnabled = false
        return btn
    }()
    
    lazy var testLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        lbl.text = "testLabel"
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .left
        return lbl
    }()
    
    // Keyboarder
    
    var isKeyboardShown: Bool = false
    
    var scrollViewOriginalContentInset: UIEdgeInsets = .zero
    
    var observerForKeyboardWillShowNotification: NSObjectProtocol?
    
    var observerForKeyboardDidShowNotification: NSObjectProtocol?
    
    var observerForKeyboardWillHideNotification: NSObjectProtocol?
    
    var observerForKeyboardDidHideNotification: NSObjectProtocol?
    
    var observerForKeyboardWillChangeFrameNotification: NSObjectProtocol?
    
    var observerForKeyboardDidChangeFrameNotification: NSObjectProtocol?
    
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
        
        registerKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        scrollViewOriginalContentInset.bottom = 20

        
       print(ConfigManager.shared.model.host)
       
       
#if DEBUG
//        ploneURLTextField.text = "https://sit.eip.kkday.net/Plone"
//        accountTextField.text = "forwindsun"
//        passwordTextFiled.text = "1234"
//        loginButton.isEnabled = true
        
//        ploneURLTextField.text = "https://eip.kkday.net/Plone"
//        accountTextField.text = "will"
//        passwordTextFiled.text = "12345"
//        loginButton.isEnabled = true
        
#endif
        
        if let resourceType: PloneResourceType<URL> = StorageManager.shared.loadObject(for: .ploneResourceType), let user: GeneralUser = StorageManager.shared.loadObject(for: .generalUser) {
            
            switch resourceType {
            case .normal(let url):
                ploneURLTextField.text = url.absoluteString
                accountTextField.text = user.account
                loginButton.isEnabled = true
                
            case .kkMember:
                ploneURLTextField.text = "KKPlone"
                accountTextField.text = ""
                passwordTextFiled.text = ""
                loginButton.isEnabled = true
                // if user login as KKMember before, trigger login automatically
                login()
                
            case .none:
                break
            }
            
            setComfirmButtonState()
            
        } else {
            print("🎯 First time login or logout")
        }
    }
    
    deinit {
        unRegisterKeyboard()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        self.view.backgroundColor = #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1)
        
        guard let scrollView = scrollView else {
            return
        }
        self.view.addSubview(scrollView)
        scrollView.addSubview(container)
        container.addSubview(inputStackView)
        self.view.addSubview(closeButton)

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
        inputStackView.addArrangedSubview(loginButton)
        
        scrollView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        container.snp.makeConstraints { maker in
            maker.edges.equalTo(self.scrollView!)
            maker.height.equalToSuperview()
            maker.width.equalToSuperview()
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
        
        loginButton.snp.makeConstraints { maker in
            maker.width.equalTo(view.snp.width).offset(-180)
            maker.height.equalTo(50)
        }
        
        closeButton.snp.makeConstraints { maker in
            maker.width.height.equalTo(20)
            maker.top.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
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
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func confirm() {
        login()
    }
    
    private func login() {
        
        print("📯 Current Host is \(ConfigManager.shared.model.host)")

        guard let urlString = ploneURLTextField.text?.trimLeadingAndTrailingWhiteSpace(), !urlString.isEmpty else {
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
            self?.setComfirmButtonState()
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
    
    private func setComfirmButtonState() {
        loginButton.isEnabled = !(ploneURLTextField.text?.isEmpty ?? true)
        loginButton.backgroundColor = !(ploneURLTextField.text?.isEmpty ?? true) ? #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
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
