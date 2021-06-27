//
//  SnackBarViewController.swift
//  KKdayPortal
//
//  Created by KKday on 2021/6/27.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

class SnackBarViewController: UIViewController {
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var snackBarButton: UIButton!
    
    static let notificationSnackBarExitName: Notification.Name = Notification.Name.init("SnackBarExit")
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        setUpUI()
    }

    func setUpLabel(mainLabelText: String, subLabelText: String, buttonIcon: UIImage?) {

        mainLabel.textAlignment = .left
        subLabel.textAlignment = .left

        mainLabel.text = mainLabelText
        subLabel.text = subLabelText

        if buttonIcon != nil {
            snackBarButton.isHidden = false
            snackBarButton.setImage(buttonIcon, for: .normal)
        } else {
            snackBarButton.isHidden = true
        }
        
    }

    private func setUpUI() {
        mainLabel.textColor = UIColor.white
        subLabel.textColor = UIColor.white
        self.view.backgroundColor = UIColor(red: 232/255, green: 141/255, blue: 133/255, alpha: 1.0)
    }

    @IBAction func hideButton(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.7, animations: {
            self.view.frame.origin.y += self.view.frame.height

        }, completion: { (_) in
            self.view.removeFromSuperview()
        })

        NotificationCenter.default.post(name: SnackBarViewController.notificationSnackBarExitName, object: self, userInfo: nil)
    }
}
