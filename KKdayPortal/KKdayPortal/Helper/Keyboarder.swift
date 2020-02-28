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
        
        observerForKeyboardWillShowNotification = notificationCenter.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil, using: { [weak self] notification in
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
        let notificationCenter = NotificationCenter.default
        
        if let observerForKeyboardWillShowNotification = observerForKeyboardWillShowNotification {
            notificationCenter.removeObserver(observerForKeyboardWillShowNotification)
        }
        
        if let observerForKeyboardDidShowNotification = observerForKeyboardDidShowNotification {
            notificationCenter.removeObserver(observerForKeyboardDidShowNotification)
        }
        
        if let observerForKeyboardWillHideNotification = observerForKeyboardWillHideNotification {
            notificationCenter.removeObserver(observerForKeyboardWillHideNotification)
        }
        
        if let observerForKeyboardDidHideNotification = observerForKeyboardDidHideNotification {
            notificationCenter.removeObserver(observerForKeyboardDidHideNotification)
        }
        
        if let observerForKeyboardWillChangeFrameNotification = observerForKeyboardWillChangeFrameNotification {
            notificationCenter.removeObserver(observerForKeyboardWillChangeFrameNotification)
        }
        
        if let observerForKeyboardDidChangeFrameNotification = observerForKeyboardDidChangeFrameNotification {
            notificationCenter.removeObserver(observerForKeyboardDidChangeFrameNotification)
        }
        
    }
    
    // KeyBoard notification implement
    func keyBoardWillShow(_ notification: Notification) {
        keyBoardWillShowHandler(notification)
        
    }
    
    func keyBoardDidShow(_ notification: Notification) {
        keyBoardDidShowHandler(notification)
    }
    
    func keyBoardWillHide(_ notification: Notification) {
        keyBoardWillHideHandler(notification)
    }
    
    func keyBoardDidHide(_ notification: Notification) {
        keyBoardDidHideHandler(notification)
    }
    
    func keyBoardWillChange(_ notification: Notification) {
        keyBoardWillChangeHandler(notification)
    }
    
    func keyBoardDidChange(_ notification: Notification) {
        keyBoardDidChangeHandler(notification)
    }
    
    // Keyboard Handler
    func keyBoardWillShowHandler(_ notification: Notification) {
        guard let scrollView = scrollView else {
            return
        }
        
        guard let userInfo = notification.userInfo else {
            return
        }
        
        guard let duration =
            userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                return
        }
        
        guard let keyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        print("⌨️ KeyBoardWillShow")
        print("KeyboardFrame: \(keyBoardFrame)")
        print("keyBoardWillShowUserInfo: \(userInfo)")
        
        UIView.animate(withDuration: duration) { [weak self] in
            
            guard let strongSelf = self else { return }
            scrollView.contentInset.bottom = strongSelf.scrollViewOriginalContentInset.bottom + keyBoardFrame.size.height
            scrollView.verticalScrollIndicatorInsets.bottom = scrollView.contentInset.bottom
        }
        
        isKeyboardShown = true
    }
    
    func keyBoardDidShowHandler(_ notification: Notification) {
        
    }
    
    func keyBoardWillHideHandler(_ notification: Notification) {
        
        isKeyboardShown = false
        
        guard let scrollView = scrollView else {
            return
        }
        
        guard let userInfo = notification.userInfo else {
            return
        }
        
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        
        UIView.animate(withDuration: duration) { [weak self] in
            
            guard let strongSelf = self else { return }
            scrollView.contentInset.bottom = strongSelf.scrollViewOriginalContentInset.bottom
            scrollView.verticalScrollIndicatorInsets.bottom = scrollView.contentInset.bottom
        }
    }
    
    func keyBoardDidHideHandler(_ notification: Notification) {
        
    }
    
    func keyBoardWillChangeHandler(_ notification: Notification) {
        
    }
    
    func keyBoardDidChangeHandler(_ notification: Notification) {
        
    }
    
}
