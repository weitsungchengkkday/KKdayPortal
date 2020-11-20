//
//  GeneralFolderViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/9.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class GeneralFolderViewModel {
    
    typealias PortalContent = GeneralItem
    
    private(set) var folderTitle: String = ""
    private(set) var generalItems: [PortalContent] = []
    
    var generalItem: PortalContent?
    
    var updateContent: () -> Void = {}
    var source: URL
    
    init(source: URL) {
        self.source = source
    }
    
    func loadPortalData() {
        
        LoadingManager.shared.setState(state: .normal(value: true))
        
        ModelLoader.PortalLoader()
            .loadItem(source: source, type: .folder) { [weak self] result in
                
                switch result {
                case .success(let generalItem):
                    LoadingManager.shared.setState(state: .normal(value: false))
                    
                    guard let generalItem = generalItem as? GeneralList else {
                        return
                    }
                    
                    if let title = generalItem.title {
                        self?.folderTitle = title
                    }
                    
                    if let items = generalItem.items {
                        self?.generalItems = items
                    }
                    
                    
                case .failure(let error):
                    print("🚨 Func: \(#file),\(#function)")
                    print("Error: \(error)")
                    LoadingManager.shared.setState(state: .normal(value: false))
                }
                
                self?.updateContent()
            }
    }
}
