//
//  UserGuideDetailViewController.swift
//  KKdayPortal
//
//  Created by KKday on 2021/4/21.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit

final class UserGuideDetailViewController: UIViewController {
    
    lazy var userGuideDetailStackView: UIStackView = {
        let stv: UIStackView = UIStackView()
        stv.axis = .vertical
        stv.alignment = .center
        stv.distribution = .fill
        stv.spacing = 50
        return stv
    }()
    
    lazy var startToUseButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Start to Use KKportal (read me first)", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.titleEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    lazy var ploneSpecButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Plone Spec", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.titleEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    lazy var ploneIntroButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("What is Plone?", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.titleEdgeInsets = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    private let viewModel: UserGuideDetailViewModel
    
    init(viewModel: UserGuideDetailViewModel) {
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
    
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        view.addSubview(userGuideDetailStackView)
        
        userGuideDetailStackView.addArrangedSubview(startToUseButton)
        userGuideDetailStackView.addArrangedSubview(ploneIntroButton)
        userGuideDetailStackView.addArrangedSubview(ploneSpecButton)
        
        userGuideDetailStackView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
        }
    }
    
    private func setAction() {
        startToUseButton.addTarget(self, action: #selector(goStartUsePage), for: .touchUpInside)
        ploneIntroButton.addTarget(self, action: #selector(goPloneIntroductionPage), for: .touchUpInside)
        ploneSpecButton.addTarget(self, action: #selector(goPloneSpecPage), for: .touchUpInside)
    }
    
    @objc private func goStartUsePage() {
        let presentViewController = StartUseViewController()
        present(presentViewController, animated: true, completion: nil)
    }
    
    @objc private func goPloneSpecPage() {
        let presentViewController = PloneSpecViewController()
        present(presentViewController, animated: true, completion: nil)
    }
    
    @objc private func goPloneIntroductionPage() {
        let presentViewController = PloneIntroViewController()
        present(presentViewController, animated: true, completion: nil)
    }

}
