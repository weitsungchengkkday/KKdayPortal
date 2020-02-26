//
//  Keyboarder.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/25.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

protocol Keyboarder: AnyObject {
    
    var isKeyboardShown: Bool { get set }
    var scrollViewOriginalContentInset: UIEdgeInsets { get set }
    var scrollView: UIScrollView? { get }
    
    // Register keyboard notification (call when viewDidLoad)
    func registerKeyboard()
    // Unregister keyboard notification (call when deinit)
    func unRegisterKeyboard()
    
    // Observer Object (Registered by KeyboardWillShow Notification)
    var observerForKeyboardWillShowNotification: NSObjectProtocol? { get set }
    // Observer Object (Registered by KeyboardDidShow Register Object)
    var observerForKeyboardDidShowNotification: NSObjectProtocol? { get set }
    // Observer Object (Registered by KeyboardWillHide Notification)
    var observerForKeyboardWillHideNotification: NSObjectProtocol? { get set }
    // Observer Object (Registered by KeyboardDidHide Notification)
    var observerForKeyboardDidHideNotification: NSObjectProtocol? { get set }
    // Observer Object (Registered by KeyboardWillChange Notification)
    var observerForKeyboardWillChangeFrameNotification: NSObjectProtocol? { get set }
    // Observer Object (Registered by KeyboardDidChange Notification)
    var observerForKeyboardDidChangeFrameNotification: NSObjectProtocol? { get set }
    
    func keyBoardWillShow(_ notification: Notification)
    func keyBoardDidShow(_ notification: Notification)
    func keyBoardWillHide(_ notification: Notification)
    func keyBoardDidHide(_ notification: Notification)
    func keyBoardWillChange(_ notification: Notification)
    func keyBoardDidChange(_ notification: Notification)
}

extension Keyboarder where Self: UIViewController {
    
    func registerKeyboard() {
        
        let notificationCenter = NotificationCenter.default
        
        observerForKeyboardWillShowNotification = notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil, using: { [weak self] notification in
            self?.keyBoardWillShow(notification)
        })
        
        observerForKeyboardDidShowNotification =
            notificationCenter.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: nil, using: { [weak self] notification in
                self?.keyBoardDidShow(notification)
            })
     
        observerForKeyboardWillHideNotification =
            notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil, using: { [weak self] notification in
                self?.keyBoardWillHide(notification)
            })
        
        observerForKeyboardDidHideNotification = notificationCenter.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: nil, using: { [weak self] notification in
            self?.keyBoardDidHide(notification)
        })
        
        observerForKeyboardWillChangeFrameNotification = notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: nil, using: { [weak self] notification in
            self?.keyBoardWillChange(notification)
        })
        
        observerForKeyboardDidChangeFrameNotification = notificationCenter.addObserver(forName: UIResponder.keyboardDidChangeFrameNotification, object: nil, queue: nil, using: { [weak self] notification in
            self?.keyBoardDidChange(notification)
        })
    }
    
    func unRegisterKeyboard() {
        
    }
    
    func keyBoardWillShow(_ notification: Notification) {
        
    }

    func keyBoardDidShow(_ notification: Notification) {
        
    }
  

}
