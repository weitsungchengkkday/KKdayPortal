//
//  GeneralRootWithLanguageNavigationController.swift
//  KKdayPortal-Sit
//
//  Created by WEI-TSUNG CHENG on 2020/1/14.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

class GeneralRootWithLanguageNavigationController: UINavigationController {
    
    var indexContents: [GeneralList]?
    
    lazy var backBarButtonItem: UIBarButtonItem = {
        let backSFConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .black, scale: .large)
        let backSFImage = #imageLiteral(resourceName: "icMenuBackWhite")
        
        return UIBarButtonItem(image: backSFImage, style: .plain, target: self, action: #selector(popToPreviousPage))
    }()
    
    lazy var indexBarButtonItem: UIBarButtonItem = {
        let indexSFConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .black, scale: .large)
        let indexSFImage = UIImage(systemName: "text.append", withConfiguration: indexSFConfig)
        
        return UIBarButtonItem(image: indexSFImage, style: .plain, target: self, action: #selector(showGeneralIndexSideBar))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
   
    func setParentLeftBarButtonItem() {
        
        if topViewController == self.viewControllers[0] {
            parent?.navigationItem.leftBarButtonItems = [
                indexBarButtonItem
            ]
        } else {
            parent?.navigationItem.leftBarButtonItems = [
                backBarButtonItem,
                indexBarButtonItem
            ]
        }
    }
    
    @objc private func popToPreviousPage() {
        self.popViewController(animated: true)
    }
    
    @objc private func showGeneralIndexSideBar() {
        
        guard let contents = indexContents else {
            return
        }
        
        let generalIndexSideBarViewModel = GeneralIndexSideBarViewModel(contentList: contents)

        let presentViewController: GeneralIndexSideBarViewController = GeneralIndexSideBarViewController(viewModel: generalIndexSideBarViewModel)

        guard let parent = navigationController?.parent else { return }
        
        parent.present(presentViewController, animated: true, completion: nil)
    }
}
