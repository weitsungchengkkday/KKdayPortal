//
//  GeneralCollectionViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/9.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import SwiftSoup

final class GeneralCollectionViewModel {
    
    typealias PortalContent = GeneralItem
    
    var generalItem: PortalContent?
    
    private(set) var collectionTitle: String = ""
    private(set) var collectionDescription: String = ""
    private(set) var generalItemsSubject: [PortalContent] = []
    
    private(set) var collectionGeneralTextObjectItems: [GeneralTextObjectSection] = []
    
    
    var updateContent: () -> Void = {}
        
    var source: URL
    
    init(source: URL) {
        self.source = source
    }
    
    func loadPortalData() {
        LoadingManager.shared.setState(state: .normal(value: true))
        
        ModelLoader.PortalLoader()
            .loadItem(source: source, type: .collection) { [weak self] result in
                
                switch result {
                case .success(let generalItem):
                    LoadingManager.shared.setState(state: .normal(value: false))
                   
                   
                    guard let generalItem = generalItem as? GeneralList else {
                        return
                    }
                    
                    self?.generalItem = generalItem
                    if let title = generalItem.title {
                        self?.collectionTitle = title
                    }
                    
                    if let description = generalItem.description {
                        self?.collectionDescription = description
                    }
                    
                    if let items = generalItem.items {
                        self?.generalItemsSubject = items
                    }
                    
                    if let textObject = generalItem.textObject {
                        
                        let generalTextObjectSections = GeneralTextObjectConverter.generalTextObjectToGeneralTextObjectSectionArray(textObject: textObject)
                        
                        self?.collectionGeneralTextObjectItems = generalTextObjectSections
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
