//
//  GeneralFileViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Alamofire
import Foundation

final class GeneralFileViewModel {
    
    typealias PortalContent = GeneralItem
    
    private(set) var fileTitle: String = ""
    private(set) var generalFileObject: GeneralFileObject?
    
    private(set) var fileLocalURL: URL!
    
    var updateContent: () -> Void = {}
    var downloadFile: () -> Void = {}
    
    var source: URL
    var generalItem: PortalContent?
    
    init(source: URL) {
        self.source = source
    }
    
    func loadPortalData() {
        LoadingManager.shared.setState(state: .normal(value: true))
        
        ModelLoader.PortalLoader()
            .loadItem(source: source, type: .file) { [weak self] result in
                
                switch result {
                case .success(let generalItem):
                    LoadingManager.shared.setState(state: .normal(value: false))
                    
                    self?.generalItem = generalItem
                    if let title = generalItem.title {
                        self?.fileTitle = title
                    }
                    
                    self?.generalFileObject = generalItem.fileObject
                    
                case .failure(let error):
                    print("🚨 Func: \(#file),\(#function)")
                    print("Error: \(error)")
                    LoadingManager.shared.setState(state: .normal(value: false))
                }
                
                self?.updateContent()
            }
    }
    
    func storeAndShare() {
        
        guard let user: GeneralUser = StorageManager.shared.loadObject(for: .generalUser) else {
            print("❌ No generalUser exist")
            return
        }
        
        let token = user.token
        let headers: [String : String] = [
            "Authorization" : "Bearer" + " " + token
        ]
        
        guard let fileName = generalItem?.id else {
            print("❌ No generalItem exist")
            return
        }
        
        guard let remoteURL = generalFileObject?.url else {
            print("❌ No generalFileObject exist")
            return
        }
        
        Alamofire.request(remoteURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseData { [weak self] dataResponse in
            
            guard let data = dataResponse.data, dataResponse.error == nil else {
                return
            }
            
            let tmpURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            
            do {
                try data.write(to: tmpURL)
            } catch {
                print("❌ write to temp URL failed")
            }
            
            self?.fileLocalURL = tmpURL
            
            self?.downloadFile()
        }
    }
    
}
