//
//  SnackBarManager.swift
//  KKdayPortal
//
//  Created by KKday on 2021/6/27.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import UIKit

final class SnackBarManager {

    static let shared: SnackBarManager = SnackBarManager()
    private let snackBarViewController: SnackBarViewController!

    private var snackBarHeight: CGFloat = 68

    private var rootViewController: UIViewController? {
        return Utilities.currentViewController
    }

    private var hiddenFrame: CGRect {

        guard let rootViewController: UIViewController = rootViewController else {
            return CGRect(x: 0, y: 0, width: 0, height: 0)
        }

        let superViewFrame: CGRect = rootViewController.view.frame
        let height: CGFloat
        let yPosition: CGFloat

        if let rootViewController = rootViewController as? SnackBarMovable {

            let snackBarDisplacement: CGFloat = rootViewController.displacement

            yPosition = superViewFrame.size.height - snackBarDisplacement
            height = snackBarHeight

        } else {
            
            let safeAreaBottom: CGFloat = rootViewController.view.safeAreaInsets.bottom

            yPosition = superViewFrame.size.height - safeAreaBottom
            height = snackBarHeight
        }

        var frame: CGRect = superViewFrame
        frame.origin.y = yPosition
        frame.size.height = height

        return frame
    }

    private var displayedFrame: CGRect {
        var frame: CGRect = self.hiddenFrame
        let hiddenY: CGFloat = frame.origin.y
        frame.origin.y = hiddenY - frame.height

        return frame
    }

    private init() {
        let storyboard: UIStoryboard = UIStoryboard(name: "SnackBarStoryboard", bundle: Bundle.main)
        self.snackBarViewController = storyboard.instantiateInitialViewController() as? SnackBarViewController
    }

    func dismiss() {
        self.snackBarViewController.view.removeFromSuperview()
    }
    
    
    func update(mainLabelText: String, subLabelText: String = "", buttonIcon: UIImage? = #imageLiteral(resourceName: "ic-close-white")) {

        if self.snackBarViewController.view.superview == nil {
            self.show(mainLabelText: mainLabelText, subLabelText: subLabelText, buttonIcon: buttonIcon)
        }

        self.snackBarViewController.view.frame = self.displayedFrame
        let hiddenFrame = self.hiddenFrame

        UIView.animate(withDuration: 0.5, animations: {
            self.snackBarViewController.view.frame = hiddenFrame
        }, completion: { (_) in
            self.dismiss()
            self.show(mainLabelText: mainLabelText, subLabelText: subLabelText, buttonIcon: buttonIcon)
        })
    }

    private func show(mainLabelText: String, subLabelText: String, buttonIcon: UIImage?) {

        guard let rootViewController: UIViewController = rootViewController else {
            return
        }

        var index: Int = 0

        if let rootViewController = rootViewController as? SnackBarMovable {
            index = rootViewController.indexOfRootViewControllerViewSubView
        } else {
            index = rootViewController.view.subviews.count
        }

        self.snackBarViewController.setUpLabel(mainLabelText: mainLabelText, subLabelText: subLabelText, buttonIcon: buttonIcon)
        self.snackBarViewController.view.frame = hiddenFrame
        let displayedFrame = self.displayedFrame
        rootViewController.view.insertSubview(self.snackBarViewController.view, at: index)

        UIView.animate(withDuration: 0.5, animations: {
            self.snackBarViewController.view.frame = displayedFrame
        })
    }
}


