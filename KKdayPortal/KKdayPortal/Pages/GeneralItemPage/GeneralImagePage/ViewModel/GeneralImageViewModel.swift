//
//  GeneralImageViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//
import UIKit
import Foundation

final class GeneralImageViewModel {
    
    typealias PortalContent = GeneralItem
    
    private(set) var imageTitle: String = ""
    private(set) var image: UIImage = #imageLiteral(resourceName: "icPicture")
    
    var generalItem: PortalContent?
    
    var updateContent: () -> Void = {}
    
    var source: URL
    
    init(source: URL) {
        self.source = source
    }
    
    func loadPortalData() {
        LoadingManager.shared.setState(state: .normal(value: true))
        
        ModelLoader.PortalLoader()
            .loadItem(source: source, type: .image) { [weak self] result in
                
                switch result {
                case .success(let generalItem):
                    LoadingManager.shared.setState(state: .normal(value: false))
                    self?.generalItem = generalItem
                    
                    if let title = generalItem.title {
                        self?.imageTitle = title
                    }
                    
                    if let imageURL = generalItem.imageObject?.url {
    
                        self?.dowloadImage(url: imageURL)
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
                    self.image = image
                    self.updateContent()
                }
            case .failure(let error):
                print("❌ Get Plone Image Failed: \(error)")
            }
            
        }
        
    }
    
}
