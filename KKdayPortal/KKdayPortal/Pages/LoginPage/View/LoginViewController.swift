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
        view.addSubview(ploneRestfulTokenButton)
        
        ploneRestfulTokenButton.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
        }
    }
    
    // 🎬 set action
    private func setAction() {
        ploneRestfulTokenButton.addTarget(self, action: #selector(goPloneSSOPage), for: .touchUpInside)
    }
    
    @objc private func goPloneSSOPage() {
        let presentViewController = PloneSSOViewController()
        present(presentViewController, animated: true, completion: nil)
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        
    }
    
}
