//
//  LoginViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/21.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit

final class UserGuideViewController: UIViewController, Localizable {
    
    // 🏞 UI element
    lazy var userGuideTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
    
    lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.titleEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.backgroundColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    lazy var goUserGuideDetailPageButton: UIButton = {
        let btn = UIButton()
        btn.titleLabel?.numberOfLines = 0
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
        btn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        
        return btn
    }()
    
    lazy var firstPageLogoImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "icKKCoolLogo")
        imv.isUserInteractionEnabled = true
        return imv
    }()
    
    private let viewModel: UserGuideViewModel
    private let testingModeTapRequired: Int = 10
    
    var observerLanguageChangedNotification: NSObjectProtocol?
    
    func refreshLanguage(_ nofification: Notification) {
        localizedText()
    }

    
    init(viewModel: UserGuideViewModel) {
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
        reigisterLanguageManager()
    }
    
    deinit {
        unregisterLanguageManager()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        localizedText()
        
        view.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        view.addSubview(backgroundImageVeiw)
        view.addSubview(userGuideTitleLabel)
        view.addSubview(loginStackView)
        view.addSubview(firstPageLogoImageView)
        
        loginStackView.addArrangedSubview(loginButton)
        loginStackView.addArrangedSubview(goUserGuideDetailPageButton)
        
        backgroundImageVeiw.snp.makeConstraints { maker in
            maker.top.equalTo(view.snp.topMargin)
            maker.bottom.equalToSuperview()
            maker.trailing.leading.equalToSuperview()
        }
        
        userGuideTitleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(view.snp.topMargin).offset(68)
            maker.trailing.equalToSuperview().offset(-10)
            maker.leading.equalToSuperview().offset(10)
        }
        
        loginStackView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints { maker in
            maker.height.equalTo(60)
            maker.width.equalTo(view.snp.width).offset(-100)
        }
        
        firstPageLogoImageView.snp.makeConstraints { maker in
            maker.width.equalTo(180)
            maker.height.equalTo(77.4)
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(view.snp.bottomMargin).offset(-44)
        }
    }
    
    private func localizedText() {
        userGuideTitleLabel.text = "user_guide_label_title".localize("歡迎使用 KKPortal!", defaultValue: "Welcome to KKPortal!")
        loginButton.setTitle("user_guide_button_login".localize("登入", defaultValue: "Login"), for: .normal)
        goUserGuideDetailPageButton.setTitle("user_guide_button_usage_guide".localize("使用說明", defaultValue: "Usage Guide"), for: .normal)
    }
    
    // 🎬 set action
    private func setAction() {
        loginButton.addTarget(self, action: #selector(goLoginInfoPage), for: .touchUpInside)
        
        goUserGuideDetailPageButton.addTarget(self, action: #selector(goPortalUserGuidePage), for: .touchUpInside)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(checkIsKKDeveloper))
        recognizer.numberOfTapsRequired = testingModeTapRequired
        firstPageLogoImageView.addGestureRecognizer(recognizer)
    }
    
    @objc private func goLoginInfoPage() {
        let viewModel = LoginViewModel()
        let presentViewController = LoginViewController(viewModel: viewModel)
        present(presentViewController, animated: true, completion: nil)
    }
    
    @objc private func goPortalUserGuidePage() {
        let presentViewController = UserGuideDetailViewController(viewModel: UserGuideDetailViewModel())
        present(presentViewController, animated: true, completion: nil)
    }
    
    @objc private func checkIsKKDeveloper() {
        
        let controller = UIAlertController(title: "進入", message: "請輸入密碼", preferredStyle: .alert)
        controller.addTextField { textField in
            textField.placeholder = "密碼"
        }
        
        let confirmAction = UIAlertAction(title: "確認", style: .default) { (_) in
            let password = controller.textFields?[0].text
            if password == "david" {
                self.goTestingPage()
            }
        }
        
        controller.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
        
    }
    
    private func goTestingPage() {
        let presentViewController = TestingViewController(viewModel: TestingViewModel())
        present(presentViewController, animated: true, completion: nil)
        
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        
    }
    
}
