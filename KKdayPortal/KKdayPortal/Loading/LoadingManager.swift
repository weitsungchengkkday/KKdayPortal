//
//  LoadingManager.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/31.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import UIKit

final class LoadingManager {
    
    static let shared: LoadingManager = LoadingManager()
    
    private let loadingViewModel: LoadingViewModel = LoadingViewModel(state: .normal(value: false))
    private let loadingViewController: LoadingViewController
    
    private weak var presentingViewController: UIViewController?
    
    private init() {
        self.loadingViewController = LoadingViewController(viewModel: loadingViewModel)
    }
    
    func setState(state: UIState<Bool>) {
        
        guard state != loadingViewModel.state else {
            return
        }
        
        loadingViewModel.state = state
        
        let content = state.content
        let value = state.value

        let currentViewController: UIViewController? = Utilities.currentViewController
        
        guard let topViewController = currentViewController?.tabBarController ?? currentViewController?.navigationController ??
            currentViewController else {
                return            
        }
        
        if value {
            switch state {
            case .normal(value: _):
                break

            case .success(value: _, message: _, duration: _, completion: let completion):
                autoDismiss(currentViewController,
                            topViewController,
                            duration: content.duration,
                            completion: completion)
                
            case .error(value: _, message: _, duration: _, completion: let completion):
                autoDismiss(currentViewController,
                            topViewController,
                            duration: content.duration,
                            completion: completion)
            }
            
            guard loadingViewController.view.superview != topViewController.view else {
                return
            }
            presentLoadingViewController(currentViewController, topViewController)
            
        } else {
            dismissLoadingViewController(currentViewController, topViewController)
        }
    
    }
    
    private func presentLoadingViewController(_ currentViewController: UIViewController?, _ topViewController: UIViewController) {
        
        guard loadingViewModel.state.value else {
            return
        }
        
        DispatchQueue.main.async {
            LoadingManager.shared.presentingViewController = topViewController
            LoadingManager.shared.loadingViewController.view.frame = topViewController.view.frame
            
            UIView.transition(with: topViewController.view, duration: 0.4, options: .transitionCrossDissolve, animations: {
                topViewController.view.addSubview(LoadingManager.shared.loadingViewController.view)
                
            }, completion: nil)
        }
    }
    
    private func dismissLoadingViewController(_ currentViewController: UIViewController?, _ topViewController: UIViewController) {
        
        DispatchQueue.main.async {
            LoadingManager.shared.presentingViewController = nil
            
            UIView.transition(with: topViewController.view, duration: 0.4, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                
                LoadingManager.shared.loadingViewController.view.removeFromSuperview()
            }, completion: nil)
        }
    }
    
    private func autoDismiss(_ currentViewController: UIViewController?, _ topViewController: UIViewController, duration: Double, completion: (() -> Bool)?) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            guard let completion = completion, completion() else {
                return
            }
            self?.dismissLoadingViewController(currentViewController, topViewController)
        }
        
    }

}
