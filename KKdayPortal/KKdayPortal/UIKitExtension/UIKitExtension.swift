//
//  UIKitExtension.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/3/7.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

extension UIWindow {
    
    func travelHierachy(_ visitor: (_ responder: UIResponder, _ level: Int) -> Void) {
        
        var stack: [(responder: UIResponder, level: Int)] = [(responder: self, level: 0)]
        
        while !stack.isEmpty {
            
            let current = stack.removeLast()
            
            switch current.responder {
            case let view as UIView:
                stack.append(contentsOf: view.subviews.reversed().compactMap({ view -> (responder: UIResponder, level: Int)? in
                    if view.isHidden {
                        return nil
                    } else {
                        return (responder: view.next as? UIViewController ?? view, level: current.level + 1)
                    }
                }))
            case let viewController as UIViewController:
                stack.append((responder: viewController.view, level: current.level + 1))
                
            default:
                break
                
            }
            
            visitor(current.responder, current.level)
        }
        
    }
    
}

extension UIWindow {
    
    static func printKeyWindowHierarchy() {
        guard let window = Utilities.appDelegateWindow else {
            return
        }
        window.printHierarchy()
    }
    
    private func printHierarchy() {
        travelHierachy { (responder, level) in
            print("Responder: \(responder),\n Level: \(level)")
        }
    }
}
