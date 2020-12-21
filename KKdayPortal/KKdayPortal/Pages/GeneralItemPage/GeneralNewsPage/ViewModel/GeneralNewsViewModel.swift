//
//  GeneralNewsViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import Alamofire

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
        
        guard let user: GeneralUser = StorageManager.shared.loadObject(for: .generalUser) else {
            print("❌ No generalUser exist")
            return
        }
        
        let token = user.token
        let headers: [String : String] = [
            "Authorization" : "Bearer" + " " + token
        ]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseData { dataResponse
            in
            
            DispatchQueue.global().async { [weak self] in
                if let data = dataResponse.data {
                    
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.newsImage = image
                        }
                    } else {
                        DispatchQueue.main.async {
                            let image = UIImage(systemName: "xmark.rectangle") ?? #imageLiteral(resourceName: "icPicture")
                            self?.newsImage = image
                        }
                    }
                }
            }
        }
    }
}
