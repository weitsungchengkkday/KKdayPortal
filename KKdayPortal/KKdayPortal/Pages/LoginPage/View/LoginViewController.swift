//
//  LoginController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/11/12.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import DolphinHTTP

final class LoginViewController: UIViewController, Keyboarder {
    
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
    
    lazy var portalConfigURLStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.distribution = .fill
        stv.alignment = .leading
        return stv
    }()
    
    lazy var portalConfigURLLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        lbl.text = "Please enter your portal config URL"
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var portalConfigURLTextField: CleanButtonTextField = {
        let txf = CleanButtonTextField()
        txf.placeholder = "https://ooo.abc.com/portal-config"
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
    
    lazy var confirmButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1), for: .normal)
        btn.setTitle("Confirm", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.isEnabled = false
        return btn
    }()
    
    // ⌨️ Keyboarder
    
    var isKeyboardShown: Bool = false
    
    var scrollViewOriginalContentInset: UIEdgeInsets = .zero
    
    var observerForKeyboardWillShowNotification: NSObjectProtocol?
    
    var observerForKeyboardDidShowNotification: NSObjectProtocol?
    
    var observerForKeyboardWillHideNotification: NSObjectProtocol?
    
    var observerForKeyboardDidHideNotification: NSObjectProtocol?
    
    var observerForKeyboardWillChangeFrameNotification: NSObjectProtocol?
    
    var observerForKeyboardDidChangeFrameNotification: NSObjectProtocol?
    
    private var viewModel: LoginViewModel!
    
    private let signiner = Signiner()
    private var singleTapGestureRecognizer: UITapGestureRecognizer!
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        viewModel = LoginViewModel()
        
        signiner.delegate = self
        
        setupUI()
        setupUIDelegate()
        createGestureRecognizer()
        setAction()
        registerKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollViewOriginalContentInset.bottom = 20
        
//        #if DEBUG
//            portalConfigURLTextField.text = "KKPortal"
//        #endif
        
        // Load Login info, if it is exist
        if let userResourceType: UserResourceType<URL> = StorageManager.shared.loadObject(for: .userResourceType) {
            
            switch userResourceType {
            case .kkMember:
                portalConfigURLTextField.text = "KKPortal"
            case .custom(let url):
                portalConfigURLTextField.text = url.absoluteString
            }
        
            setComfirmButtonState()
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

        inputStackView.addArrangedSubview(portalConfigURLStackView)
        portalConfigURLStackView.addArrangedSubview(portalConfigURLLabel)
        portalConfigURLStackView.addArrangedSubview(portalConfigURLTextField)
        
        inputStackView.addArrangedSubview(accountStackView)
        accountStackView.addArrangedSubview(accountLabel)
        accountStackView.addArrangedSubview(accountTextField)
       
        inputStackView.addArrangedSubview(passwordStackView)
        passwordStackView.addArrangedSubview(passwordLabel)
        passwordStackView.addArrangedSubview(passwordTextFiled)
        
        inputStackView.addArrangedSubview(memoTextView)
        inputStackView.addArrangedSubview(confirmButton)
        
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
        
        portalConfigURLLabel.snp.makeConstraints { maker in
            maker.width.equalTo(view.snp.width).offset(-120)
        }
        
        portalConfigURLTextField.snp.makeConstraints { maker in
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
        
        confirmButton.snp.makeConstraints { maker in
            maker.width.equalTo(view.snp.width).offset(-180)
            maker.height.equalTo(50)
        }
        
        closeButton.snp.makeConstraints { maker in
            maker.width.height.equalTo(20)
            maker.top.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
        }
        
    }
    
    func setupUIDelegate() {
        portalConfigURLTextField.delegate = self
        accountTextField.delegate = self
        passwordTextFiled.delegate = self
    }
    
    private func createGestureRecognizer() {
        singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handerSingleTap))
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
    }

    @objc func handerSingleTap() {
        self.portalConfigURLTextField.resignFirstResponder()
        self.accountTextField.resignFirstResponder()
        self.passwordTextFiled.resignFirstResponder()
    }
    
    // 🎬 set action
    private func setAction() {
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func confirm() {
        login()
    }
    
    private func login() {
        
        guard let urlString = portalConfigURLTextField.text?.trimLeadingAndTrailingWhiteSpace(), !urlString.isEmpty else {
            return
        }
        
        switch urlString {
        case "KKPortal":
            print("✈️ KK Member login")
            // load ConfigModel.json file
            ConfigManager.shared.setup()
            
            viewModel.getKKUserPortalConfig { [weak self] isSuccess in
                
                DispatchQueue.main.async {
                    
                    if isSuccess {
                        UserResourceManager.shared.resourceType = .kkMember
                            self?.goPloneSSOPage()
                        
                    } else {
                        let alertController = UIAlertController(title: "Warning", message: "Can't get KKUser portal config", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                        self?.present(alertController, animated: true, completion: nil)
                        return
                    }
                }
            }
            
        default:
            
            print("🗺 Custom user login")
            guard let url = URL(string: urlString) else {
                let alertController = UIAlertController(title: "Warning", message: "Not valid URL, please check", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
                return
            }
            
            viewModel.getCustomUserPortalConfig(url: url) { [weak self] result in
                
                DispatchQueue.main.async {
                    
                    switch result {
                    case .success(let config):
                        
                        UserResourceManager.shared.resourceType = .custom(url)
                        
                        guard let signinURL: URL = URL(string: config.data.login.url) else {
                            let alertController = UIAlertController(title: "Warning", message: "Plone login URL is invalid", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self?.present(alertController, animated: true, completion: nil)
                            return
                        }
                        
                        self?.signiner.signin(url: signinURL, account: self?.accountTextField.text ?? "", password: self?.passwordTextFiled.text ?? "")
                        
                    case .failure(let error):
                        
                        print("❌ Error: \(error)")
                        let alertController = UIAlertController(title: "Warning", message: "Can't get portal config", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alertController.addAction(alertAction)
                        self?.present(alertController, animated: true, completion: nil)
                        return
                    }
                }
            }
        }
    }
    
    private func goPloneSSOPage() {
        let presentViewController = PloneSSOViewController(viewModel: PloneSSOViewModel())
        present(presentViewController, animated: true, completion: nil)
    }
    
    private func directlyGoMainViewController() {
        let presentViewController = MainViewController()
        presentViewController.modalPresentationStyle = .fullScreen
        present(presentViewController, animated: true, completion: nil)
    }
    
    private func setComfirmButtonState() {
        confirmButton.isEnabled = !(portalConfigURLTextField.text?.isEmpty ?? true)
        confirmButton.backgroundColor = !(portalConfigURLTextField.text?.isEmpty ?? true) ? #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }

}

extension LoginViewController: SigninDelegate {
    
    func signinSuccess(_ signiner: Signiner, generalUser user: GeneralUser) {
        
        let token = user.token
        let account = user.account
        
        debugPrint("👥 Normal Login, Get Token 💎PLONE TOKEN: \(token)")
        
        let user = GeneralUser(account: account, token: token)
        StorageManager.shared.saveObject(for: .generalUser, value: user)
        directlyGoMainViewController()
    }
    
    func signinFailed(_ signiner: Signiner, signinError error: HTTPError) {
        
        debugPrint("🚨 Normal Login, Get Error: \(error)")
       
        let alertController = UIAlertController(title: "Warning", message: "Login Failed, Please Check your ploneURL, account, and password", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField == portalConfigURLTextField {
            setComfirmButtonState()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case portalConfigURLTextField:
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
