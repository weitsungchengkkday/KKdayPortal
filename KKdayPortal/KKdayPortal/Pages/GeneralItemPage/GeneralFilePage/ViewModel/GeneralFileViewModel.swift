//
//  GeneralFileViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

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

        guard let fileNameExtension = generalItem?.id?.fileNameExtension() else {
            print("❌ Without fileName extension")
            return
        }

        let fullFileName = self.fileTitle + "." + fileNameExtension

        guard let url = generalFileObject?.url else {
            print("❌ No generalFileObject exist")
            return
        }
        
        let api = PloneFileAPI()
        
        api.getPloneFile(url: url) { result in
            
            switch result {
            case .success(let data):
                let tmpURL = FileManager.default.temporaryDirectory.appendingPathComponent(fullFileName)
                do {
                    try data.write(to: tmpURL)
                } catch {
                    print("❌ write to temp URL failed")
                }
                DispatchQueue.main.async {
                    self.fileLocalURL = tmpURL
                    self.downloadFile()
                }
                
            case .failure(let error):
                print("❌ Get Plone File Failed: \(error)")
            }
            
        }

    }
    
    
}

