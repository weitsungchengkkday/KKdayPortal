//
//  SocailLoginViewController.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/17.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit
import GoogleSignIn
import SnapKit

protocol GoogleSigniner: GIDSignInDelegate {
    func setupGoogleLogin()
}

final class SocailLoginViewController: UIViewController, GoogleSigniner {
    
    // 🏞 UI element
    lazy var signInButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Google Sign In", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    lazy var signOutButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Google Sign Out", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 4
        return btn
    }()
    
    func setupGoogleLogin() {
        GIDSignIn.sharedInstance().clientID =  "990129674791-p91l825tt7sp1ri2ot9mv14h0ffl914s.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
    }
    
    // Google Sign-in
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("❗️The user has not signed in before or they have since signed out.")
            } else {
                print("Error: \(error.localizedDescription)")
            }
            return
        }
        
        let userId = user.userID
        let accessToken = user.authentication.idToken
        let fullName = user.profile.name
        let email = user.profile.email
        
        let googleUser = GoogleUser(userId: userId,
                                    email: email,
                                    acesstoken: accessToken,
                                    fullName: fullName)
        
        StorageManager.shared.saveObject(for: .googleUser, value: googleUser)
        
        print(
            """
            🌐 Google Sign In
            userId: \(userId ?? "")
            accessToken: \(accessToken ?? "")
            fullName: \(fullName ?? "")
            email: \(email ?? "")
            """
        )
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("Error: \(error.localizedDescription)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        setupUI()
        setAction()
        setupGoogleLogin()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
    }
    
    // 🎨 draw UI
    private func setupUI() {
        view.addSubview(signInButton)
        view.addSubview(signOutButton)
        
        signInButton.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(40)
            maker.centerX.equalToSuperview()
        }
        
        signOutButton.snp.makeConstraints { maker in
            maker.top.equalTo(signInButton.snp.bottom).offset(20)
            maker.centerX.equalToSuperview()
        }
    }
    
    // 🎬 set action
    private func setAction() {
        
        signInButton.addTarget(self, action: #selector(signInGoogle), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(signOutGoogle), for: .touchUpInside)
    }
    
    @objc private func signInGoogle() {
        
        guard let signIn = GIDSignIn.sharedInstance() else {
            return
        }
        
        if (signIn.hasPreviousSignIn()) {
            signIn.restorePreviousSignIn()
    
            if signIn.currentUser == nil || signIn.currentUser.authentication.clientID != "990129674791-p91l825tt7sp1ri2ot9mv14h0ffl914s.apps.googleusercontent.com" {
                signIn.signOut()
            }
            
        } else {
            // Defualt scope:
            // [https://www.googleapis.com/auth/userinfo.email, openid, https://www.googleapis.com/auth/userinfo.profile]
            signIn.signIn()
        }
    }
    
    @objc private func signOutGoogle() {
        guard let signIn = GIDSignIn.sharedInstance() else {
            return
        }
        signIn.signOut()
    }
}
