//
//  HomeViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/14.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import SnapKit

import PushKit

protocol PushKitEventDelegate: AnyObject {
    func credentialsUpdated(credentials: PKPushCredentials) -> Void
    func credentialsInvalidated() -> Void
    func incomingPushReceived(payload: PKPushPayload, completion: @escaping () -> Void) -> Void
}

final class HomeViewController: UIViewController, Localizable, NetStatusProtocal {
    
    // 🏞 UI element
    private lazy var homeContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    var observerLanguageChangedNotification: NSObjectProtocol?
    
    func refreshLanguage(_ nofification: Notification) {
        localizedText()
    }
    
    var pushKitEventDelegate: PushKitEventDelegate?
    
    var voipRegistry = PKPushRegistry.init(queue: .main)
    
    var observerNetStatusChangedNotification: NSObjectProtocol?
    
    func noticeNetStatusChanged(_ nofification: Notification) {
        checkNetStatusSnackBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Twilio Call Service
        self.pushKitEventDelegate = TwilioServiceManager.shared.twiVC
        initializePushKit()
        
        setupUI()
        setAction()
        registerLanguageManager()
        checkNetStatusSnackBar()
        
        registerLanguageManager()
        registerNetStatusManager()
        addChildViewController()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkNetStatusSnackBar()
    }
    
    deinit {
        unregisterNetStatusManager()
        unregisterLanguageManager()
    }
    
    private func initializePushKit() {
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
    }
    
    // 🎨 draw UI
    private func setupUI() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        localizedText()
        
        self.view.addSubview(homeContainerView)
        homeContainerView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide)
            maker.leading.equalTo(view.safeAreaLayoutGuide)
            maker.trailing.equalTo(view.safeAreaLayoutGuide)
            maker.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func addChildViewController() {
        
        guard let config: PortalConfig = StorageManager.shared.loadObject(for: .portalConfig), let portalService = config.data.services.filter({$0.type == "portal" && $0.name == "plone"}).first else {
            print("❌ Can't get plone portal service in portalConfig")
            return
        }
        
        guard let rootURL = URL(string: portalService.url + "/zh-tw") else {
            print("❌ Portal root URL is invalid")
            return
        }
       
        let viewModel = GeneralRootWithLanguageDocumentViewModel(source: rootURL)
        let childViewController = GeneralRootWithLanguageDocumentViewController(viewModel: viewModel)
        addChild(childViewController)
        childViewController.view.frame = homeContainerView.bounds
        
        homeContainerView.addSubview(childViewController.view)
        childViewController.didMove(toParent: self)
    }
    
    // 🧾 localization
    private func localizedText() {
        self.title = "home_title".localize("主頁", defaultValue: "Home")
    }
    
    // 🎬 set action
    private func setAction() {
        
    }
    
    // ⛓ bind viewModel
    private func bindViewModel() {
        
    }
}


// MARK: PKPushRegistryDelegate
extension HomeViewController: PKPushRegistryDelegate {
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        print("〽️ pushRegistry:didUpdatePushCredentials:forType:")
        
        if let delegate = self.pushKitEventDelegate {
            print("〽️ update push credentials")
            delegate.credentialsUpdated(credentials: pushCredentials)
        } else {
            print("〽️⚠️ pushKitEventDelegate is not set")
        }
        
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("〽️ pushRegistry:didInvalidatePushTokenForType:")
        
        if let delegate = self.pushKitEventDelegate {
            print("〽️⚠️ Invalidate Push Token")
            delegate.credentialsInvalidated()
        } else {
            print("〽️⚠️ pushKitEventDelegate is not set")
        }
        
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        print("〽️ pushRegistry:didReceiveIncomingPushWithPayload:forType:completion:")
        print(type.rawValue)

        if let delegate = self.pushKitEventDelegate {
            print("〽️recieve payload: \(payload.dictionaryPayload) ")
           
            delegate.incomingPushReceived(payload: payload, completion: completion)
            
        } else {
            print("〽️⚠️ pushKitEventDelegate is not set")
        }

    }
    
}
