//
//  PloneCoordinator.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/30.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import UIKit

protocol PloneCoordinator where Self: UIViewController {
    func goDetailPage(route: URL, type: PloneItemType)
}

extension PloneCoordinator {
    func goDetailPage(route: URL, type: PloneItemType) {
        
        debugPrint("GoDetail: rout: \(route), type: \(type)")
        
        let apiManager = APIManager.default
        
        switch type {
        case .root:
            let pushViewController = PloneRootViewController(viewModel: PloneRootViewModel(apiManager: apiManager, route: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            
        case .folder:
            let pushViewController = PloneFolderViewController(viewModel: PloneFolderViewModel(apiManager: apiManager, route: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            
        case .document:
            let pushViewController = PloneDocumentViewController(viewModel: PloneDocumentViewModel(apiManager: apiManager, route: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            
        case .news:
            let pushViewController = PloneNewsViewController(viewModel: PloneNewsViewModel(apiManager: apiManager, route: route))
            navigationController?.pushViewController(pushViewController, animated: false)
        case .event:
            let pushViewController = PloneEventViewController(viewModel: PloneEventViewModel(apiManager: apiManager, route: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            
        case .image:
            let pushViewController = PloneImageViewController(viewModel: PloneImageViewModel(apiManager: apiManager, route: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            
        case .file:
            let pushViewController = PloneFileViewController(viewModel: PloneFileViewModel(apiManager: apiManager, route: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            
        case .link:
            let pushViewController = PloneLinkViewController(viewModel: PloneLinkViewModel(apiManager: apiManager, route: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            
        case .collection:
            let pushViewController = PloneCollectionViewController(viewModel: PloneCollectionViewModel(apiManager: apiManager, route: route))
            navigationController?.pushViewController(pushViewController, animated: false)
        }
    }
}
