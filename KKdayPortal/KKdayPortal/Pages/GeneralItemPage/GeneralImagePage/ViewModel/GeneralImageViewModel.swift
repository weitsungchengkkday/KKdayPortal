//
//  GeneralImageViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Alamofire

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
                    
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data) {
                            self?.image = image
                            
                        } else {
                            let image = UIImage(systemName: "xmark.rectangle") ?? #imageLiteral(resourceName: "icPicture")
                            self?.image = image
                        }
                        self?.updateContent()
                    }
                }
                
            }
            
        }
    }
    
}
