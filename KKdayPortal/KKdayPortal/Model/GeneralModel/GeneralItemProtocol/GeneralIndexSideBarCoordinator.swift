//
//  GeneralIndexSideBarCoordinator.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/16.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import UIKit

protocol GeneralIndexSideBarCoordinator where Self: UIViewController {
    func goDetailIndexPage(route: URL, type: GeneralItemType)
}

extension GeneralIndexSideBarCoordinator {
    func goDetailIndexPage(route: URL, type: GeneralItemType) {
        
        debugPrint("GoDetail: rout: \(route), type: \(type)")
    
        guard let firstVC = navigationController?.viewControllers.first else {
            return
        }
        navigationController?.viewControllers = [firstVC]
        
        switch type {
        case .root:
            let pushViewController = GeneralRootWithLanguageViewController(viewModel: GeneralRootWithLanguageViewModel(source: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            
        case .root_with_language:
            let pushViewController = GeneralRootViewController(viewModel: GeneralRootViewModel(source: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            
        case .folder:
            let pushViewController = GeneralFolderViewController(viewModel: GeneralFolderViewModel(source: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            
        case .collection:
            let pushViewController = GeneralCollectionViewController(viewModel: GeneralCollectionViewModel(source: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            
        case .image:
            let pushViewController = GeneralImageViewController(viewModel: GeneralImageViewModel(source: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            
        case .document:
            let pushViewController = GeneralDocumentViewController(viewModel: GeneralDocumentViewModel(source: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            
        case .news:
            let pushViewController = GeneralNewsViewController(viewModel: GeneralNewsViewModel(source: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            
        case .event:
            let pushViewController = GeneralEventViewController(viewModel: GeneralEventViewModel(source: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            
        case .file:
            let pushViewController = GeneralFileViewController(viewModel: GeneralFileViewModel(source: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            
        case .link:
            // If link is BPM open website in APP
            if route == URL(string: "https://sit.eip.kkday.net/Plone/zh-tw/02-all-services/bpm") {
                
                guard let currentViewController = Utilities.currentViewController as? GeneralIndexSideBarViewController else {
                    return
                }
                guard let tab = currentViewController.presentingViewController as? MainViewController else {
                    return
                }
                
                tab.selectedIndex = 0
                
                return
            }
            
            // Others jump out from APP
            if UIApplication.shared.canOpenURL(route) {
                UIApplication.shared.open(route, options: [:], completionHandler: nil)
            }
            
        }
    }
}
