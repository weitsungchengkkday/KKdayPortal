//
//  GeneralDocumentViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class GeneralDocumentViewModel {
    
    typealias PortalContent = GeneralItem
    
    private(set) var documentTitle: String = ""
    private(set) var documentDescription: String = ""
    private(set) var documentGeneralTextObjectItems: [GeneralTextObjectSection] = []
    
    var generalItem: PortalContent?
    
    var upateContent: () -> Void = {}
    
    var source: URL
    
    init(source: URL) {
        self.source = source
    }
    
    func loadPortalData() {
        LoadingManager.shared.setState(state: .normal(value: true))
        ModelLoader.PortalLoader()
            .loadItem(source: source, type: .document) { [weak self] result in
                
                switch result {
                case .success(let generalItem):
                    LoadingManager.shared.setState(state: .normal(value: false))
                    self?.generalItem = generalItem
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
                    
                case .failure(let error):
                    print("🚨 Func: \(#file),\(#function)")
                    print("Error: \(error)")
                    LoadingManager.shared.setState(state: .normal(value: false))
                }
                
                self?.upateContent()
            }
    }
    
}
