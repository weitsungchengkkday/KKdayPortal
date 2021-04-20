//
//  GeneralDetailPageCoordinator.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/16.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import UIKit

protocol GeneralDetailPageCoordinator where Self: UIViewController {
    func openDetailPage(route: URL, type: GeneralItemType)
    func openOutSiteLink(url: URL)
    
}

extension GeneralDetailPageCoordinator {
    
   func openDetailPage(route: URL, type: GeneralItemType) {
        
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = ""
        navigationController?.navigationBar.topItem?.backBarButtonItem  = barButtonItem
        debugPrint("🏷 GoDetail: rout: \(route), type: \(type)")
        
        switch type {
        case .root:
            let pushViewController = GeneralRootWithLanguageDocumentViewController(viewModel: GeneralRootWithLanguageDocumentViewModel(source: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            
        case .root_with_language:
            break
            
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
            
            let resourceType = PloneResourceManager.shared.resourceType
                   
            switch resourceType {
            case .kkMember:
                break
                
            case .normal:
                break
                
            case .none:
                print("❌, resourceType must be defined")
                return
            }
            
            let pushViewController = GeneralLinkViewController(viewModel: GeneralLinkViewModel(source: route))
            navigationController?.pushViewController(pushViewController, animated: false)
            
        }
    }
    
    func openOutSiteLink(url: URL) {
        
        let alertController = UIAlertController(title: "Warning", message: "Will Jump Out APP", preferredStyle: .actionSheet)
        let confirmAlertAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAlertAction)
        alertController.addAction(cancelAlertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
