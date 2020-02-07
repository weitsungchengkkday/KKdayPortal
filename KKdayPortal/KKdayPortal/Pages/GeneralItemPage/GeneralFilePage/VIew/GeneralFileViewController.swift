//
//  GeneralFileViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import WebKit

final class GeneralFileViewController: UIViewController {
    
    // 🏞 UI element
    lazy var logoImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = #imageLiteral(resourceName: "icKKdayLogo")
        return imv
    }()
    
    lazy var topTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 24)
        return lbl
    }()
    
    lazy var displayFileWebView: WKWebView = {
        let wkv = WKWebView()
        wkv.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        wkv.navigationDelegate = self
        return wkv
    }()
    
    private lazy var loadingActivityIndicatorContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    private lazy var loadingActivityIndicatorView: UIActivityIndicatorView = {
        let idv = UIActivityIndicatorView(style: .large)
        idv.color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return idv
    }()
    
    lazy var downloadFileButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        btn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        btn.setTitle("Download or Share", for: .normal)
        btn.layer.cornerRadius = 5
        return btn
    }()
    
    private let viewModel: GeneralFileViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: GeneralFileViewModel) {
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
        bindViewModel()
        viewModel.getPortalData()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.addSubview(logoImageView)
        view.addSubview(topTitleLabel)
        view.addSubview(displayFileWebView)
        displayFileWebView.addSubview(loadingActivityIndicatorContainerView)
        loadingActivityIndicatorContainerView .addSubview(loadingActivityIndicatorView)
        view.addSubview(downloadFileButton)
        
        logoImageView.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.snp.topMargin)
            maker.leading.equalToSuperview()
        }
        
        topTitleLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(logoImageView.snp.trailing)
            maker.trailing.equalToSuperview()
            maker.centerY.equalTo(logoImageView.snp.centerY)
        }
        
        displayFileWebView.snp.makeConstraints { maker in
            maker.top.equalTo(logoImageView.snp.bottom)
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(downloadFileButton.snp.top).offset(-8)
        }
        loadingActivityIndicatorContainerView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.width.equalTo(65)
            maker.height.equalTo(65)
        }
        
        loadingActivityIndicatorView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.width.equalTo(60)
            maker.height.equalTo(00)
        }
        
        downloadFileButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-8)
            maker.width.equalToSuperview().offset(-30)
            maker.height.equalTo(44)
        }
    }
    
    // 🎬 set action
    private func setAction() {
        downloadFileButton.addTarget(self, action: #selector(downloadFile), for: .touchUpInside)
    }
    
    @objc private func downloadFile() {
        viewModel.storeAndShare()
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        
        viewModel.output.showTitle
            .drive(onNext: { [weak self] title in
                self?.topTitleLabel.text = title
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showGeneralFileObject
            .drive(onNext: { [weak self] generalFileObject in
                
                guard let generalFileObject = generalFileObject else {
                    print("❌, No generalFileObject")
                    return
                }
                self?.displayFileWebView.load(URLRequest(url: generalFileObject.url))
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showLocalURL
            .drive(onNext: { [weak self] tmpURL in
                guard let tmpURL = tmpURL else {
                    return
                }
                
                let activity = UIActivityViewController(activityItems: [tmpURL], applicationActivities: nil)
                self?.present(activity, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

extension GeneralFileViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("\(#function) load start")
        showActivityInicator(true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("\(#function) load finished")
        showActivityInicator(false)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        let error = error as NSError
        switch error.code {
        case -1001:
            print("\(#function) error is 'TimeOut'")
        case -1003:
            print("\(#function) error is 'Server cannot be found'")
        case -1009:
            print("\(#function) error is 'Offline'")
        case -1100:
            print("\(#function) error is 'URL not be found on server'")
        default:
            ()
        }
        
        print(error)
        showActivityInicator(false)
    }
    
    private func showActivityInicator(_ bool: Bool) {
        if bool {
            loadingActivityIndicatorView.startAnimating()
            loadingActivityIndicatorContainerView.isHidden = false
        } else {
            loadingActivityIndicatorView.stopAnimating()
            loadingActivityIndicatorContainerView.isHidden = true
        }
    }
}






extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
