//
//  GeneralRootWithLanguageViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/8.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import DolphinHTTP

final class GeneralRootWithLanguageDocumentViewModel {
    
    typealias PortalContent = GeneralItem
    typealias PortalContentList = GeneralList
    
    var generalItem: PortalContentList? {
        didSet {
            updateDocumentContent()
        }
    }
    
    var generalItemDocument: PortalContent?
    
    private(set) var documentTitle: String = ""
    private(set) var documentDescription: String = ""
    private(set) var documentGeneralTextObjectItems: [GeneralTextObjectSection] = []
    
    var updateDocumentContent: () -> Void = {}
    
    var source: URL
    
    init(source: URL) {
        self.source = source
    }
    
    func loadPortalData() {
        LoadingManager.shared.setState(state: .normal(value: true))
        
        ModelLoader.PortalLoader()
            .loadItem(source: source, type: .root_with_language) { [weak self] result in
                
                switch result {
                case .success(let generalItem):
                    
                    LoadingManager.shared.setState(state: .normal(value: false))
                    
                    guard let generalItem = generalItem as? GeneralList else {
                        return
                    }
                    
                    self?.generalItem = generalItem
                    
                    if let items = generalItem.items {
                        let documentItem = items.filter ({ $0.type == .document })
                        
                        self?.generalItemDocument = documentItem.first
                    }
                    self?.loadPortalDocumentData()
                    
                case .failure(let error):
                    
                    print("🚨 Func: \(#file),\(#function)")
                    print("Error: \(error)")
                    LoadingManager.shared.setState(state: .normal(value: false))
                }
            }
    }
    
    private func loadPortalDocumentData() {
        guard let source = generalItemDocument?.source else {
            return
        }
        
        ModelLoader.PortalLoader()
            .loadItem(source: source, type: .document) { [weak self] result in
                
                LoadingManager.shared.setState(state: .normal(value: true))
                
                switch result {
                case .success(let generalItem):
                    LoadingManager.shared.setState(state: .normal(value: false))
                    
                    if let generalItemSource = generalItem.source,
                       let generalItemDocumentSource = self?.generalItemDocument?.source,
                       generalItemSource == generalItemDocumentSource {
                        
                        self?.generalItemDocument = generalItem
                        
                        if let title = generalItem.title {
                            self?.documentTitle = title
                        }
                        
                        if let description = generalItem.description {
                            self?.documentDescription = description
                        }
                        
                        if let textObject = generalItem.textObject {
                            let generalTextObjectSections = GeneralTextObjectConverter.generalTextObjectToGeneralTextObjectSectionArray(textObject: textObject)
                            self?.documentGeneralTextObjectItems = generalTextObjectSections
                        }
                        
                    }
                case .failure(let error):
                    print("🚨 Func: \(#file),\(#function)")
                    print("Error: \(error)")
                    LoadingManager.shared.setState(state: .normal(value: false))
                }
            }
        
    }
    
}

