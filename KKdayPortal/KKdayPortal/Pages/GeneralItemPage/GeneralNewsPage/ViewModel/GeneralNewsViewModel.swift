//
//  GeneralNewsViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import UIKit

final class GeneralNewsViewModel {
    
    typealias PortalContent = GeneralItem
    
    var generalItem: PortalContent?
    
    private(set) var newsTitle: String = ""
    private(set) var newsDescription: String = ""
    private(set) var newsImage: UIImage = UIImage()
    private(set) var newsGeneralTextObjectItems: [GeneralTextObjectSection] = []
    
    var updateContent: () -> Void = {}
    
    var source: URL
    
    init(source: URL) {
        self.source = source
    }
    
    func loadPortalData() {
        
        LoadingManager.shared.setState(state: .normal(value: true))
        
        ModelLoader.PortalLoader()
            .loadItem(source: source, type: .news) { [weak self] result in
                
                switch result {
                case .success(let generalItem):
                    LoadingManager.shared.setState(state: .normal(value: false))
                    
                    self?.generalItem = generalItem
                  
                    if let title = generalItem.title {
                        self?.newsTitle = title
                    }
                    
                    if let description = generalItem.description {
                        self?.newsDescription = description
                    }
                    
                    if let imageURL = generalItem.imageObject?.url {
                        self?.dowloadImage(url: imageURL)
                    }
                    
                    if let textObject = generalItem.textObject {
                        
                        let generalTextObjectSections = GeneralTextObjectConverter.generalTextObjectToGeneralTextObjectSectionArray(textObject: textObject)
                        self?.newsGeneralTextObjectItems = generalTextObjectSections
                    }
                    
                case .failure(let error):
                    print("🚨 Func: \(#file),\(#function)")
                    print("Error: \(error)")
                    LoadingManager.shared.setState(state: .normal(value: false))
                    
                }
                
                self?.updateContent()
            }
    }
    
    private func dowloadImage(url: URL) {
        
        let api = PloneImageAPI()
        api.getPloneImage(url: url) { result in
            
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.newsImage = image
                    self.updateContent()
                }
            case .failure(let error):
                print("❌ Get Plone Image Failed: \(error)")
            }
        }
    }
}
