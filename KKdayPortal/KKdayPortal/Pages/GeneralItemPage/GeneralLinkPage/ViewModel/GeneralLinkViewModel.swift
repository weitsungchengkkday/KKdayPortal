//
//  GeneralLinkViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class GeneralLinkViewModel {
    
    typealias PortalContent = GeneralItem
    
    private(set) var linkTitle: String = ""
    
    var generalItem: PortalContent?
    var linkURL: URL?
    var updateContent: () -> Void = {}
    
    var source: URL
    
    init(source: URL) {
        self.source = source
    }
    
    func loadPortalData() {
        LoadingManager.shared.setState(state: .normal(value: true))
        
        ModelLoader.PortalLoader()
            .loadItem(source: source, type: .link) { [weak self] result in
                
                switch result {
                case .success(let generalItem):
                    LoadingManager.shared.setState(state: .normal(value: false))
                    self?.generalItem = generalItem
                    if let title = generalItem.title {
                        self?.linkTitle = title
                    }
                    
                    self?.linkURL = generalItem.linkObject?.url
                    
                    
                case .failure(let error):
                    print("🚨 Func: \(#file),\(#function)")
                    print("Error: \(error)")
                    LoadingManager.shared.setState(state: .normal(value: false))
                }
                
                self?.updateContent()
            }
        
    }
    
}



