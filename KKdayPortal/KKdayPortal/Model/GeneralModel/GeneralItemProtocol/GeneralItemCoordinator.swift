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
    func goDetailPageInWebView(route: URL, type: GeneralItemType)
}

extension GeneralItemCoordinator {
    func goDetailPage(route: URL, type: GeneralItemType) {
        
        debugPrint("GoDetail: rout: \(route), type: \(type)")
        
        switch type {
        case .root:
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
            let pushViewController = GeneralLinkViewController(viewModel: GeneralLinkViewModel(source: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            
        }
    }
}


extension GeneralItemCoordinator {

    func goDetailPageInWebView(route: URL, type: GeneralItemType) {
        
        debugPrint("GoDetailInWebView: rout: \(route), type: \(type)")
        switch type {
        case .link:
            let pushViewController = ApplicationsContentViewController(viewModel: ApplicationsContentViewModel(source: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            break
        default:
            return
        }
    }
}
