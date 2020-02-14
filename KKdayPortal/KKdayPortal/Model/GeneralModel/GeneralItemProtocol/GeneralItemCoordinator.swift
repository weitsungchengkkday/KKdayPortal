//
//  GeneralItemCoordinator.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import UIKit

protocol GeneralItemCoordinator where Self: UIViewController {
    func goDetailPage(route: URL, type: GeneralItemType)
}

extension GeneralItemCoordinator {
    func goDetailPage(route: URL, type: GeneralItemType) {
        
        debugPrint("GoDetail: rout: \(route), type: \(type)")
        
        switch type {
        case .root:
            let pushViewController = GeneralRootViewController(viewModel: GeneralRootViewModel(source: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            
        case .root_with_language:
            let pushViewController = GeneralRootWithLanguageDocumentViewController(viewModel: GeneralRootWithLanguageDocumentViewModel(source: route))
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
                
                guard let currentViewController = Utilities.currentViewController as? GeneralRootWithLanguageFoldersViewController else {
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
