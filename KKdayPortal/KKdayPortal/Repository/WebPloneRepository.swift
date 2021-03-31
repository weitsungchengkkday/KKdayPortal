//
//  WebPloneRepository.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/7.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import DolphinHTTP

final class WebPloneRepository {
    
    typealias User = GeneralUser
    typealias Item = GeneralItem
    
    static var baseURL: URL {
        
        let resourceType = PloneResourceManager.shared.resourceType
        
        switch resourceType {
        case .kkMember:
            
            let service: PortalService? = StorageManager.shared.loadObject(for: .plonePortalService)
            
            guard let element = service!.elements.filter({ $0.name == "Website URL"}).first else {
                print("❌ Can't Get Plone URL")
                return URL(string: "https://www.kkday.com")!
            }
            
            return URL(string: element.content + "/Plone")!
            
        case .normal(url: let url):
            return url
        case .none:
            print("⚠️ Warning, without resourceType")
            return URL(string: "https://www.kkday.com")!
        }
    }
    
    private let api = PloneItemsAPI()
    private var source: URL
    
    private var user: User? {
        let user: User? = StorageManager.shared.loadObject(for: .generalUser)
        return user
    }
    
    private var ploneUser: PloneUser? {
        guard let user = user else {
            return nil
        }
        
        let ploneUser: PloneUser = PloneUser(account: user.account,
                                             token: user.token)
        return ploneUser
    }
    
    init(source: URL = WebPloneRepository.baseURL) {
        self.source = source
    }
    
    func loadItem(generalItemType: GeneralItemType, completion: @escaping (Result<GeneralItem, HTTPError>) -> Void) {
        
        let ploneItemType = ItemConverter.typeTransfer(generalItemType: generalItemType)
        
        switch ploneItemType {
        case .lrf:
            api.getPloneItem(user: ploneUser, route: source, ploneType: PloneLRF.self) { result in
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let ploneItem):
                        
                        let generalItem =  ItemConverter.ploneItemToGeneralItem(item: ploneItem)
                        completion(.success(generalItem))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
            
        case .ploneSite:
            api.getPloneItem(user: ploneUser, route: source, ploneType: PloneSiteItem.self) { result in
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let ploneItem):
                        let generalItem =  ItemConverter.ploneItemToGeneralItem(item: ploneItem)
                        completion(.success(generalItem))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
            
        case .folder:
            api.getPloneItem(user: ploneUser, route: source, ploneType: PloneFolder.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let ploneItem):
                        let generalItem =  ItemConverter.ploneItemToGeneralItem(item: ploneItem)
                        completion(.success(generalItem))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
            
        case .document:
            api.getPloneItem(user: ploneUser, route: source, ploneType: PloneDocument.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let ploneItem):
                        let generalItem =  ItemConverter.ploneItemToGeneralItem(item: ploneItem)
                        completion(.success(generalItem))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
            
        case .news:
            api.getPloneItem(user: ploneUser, route: source, ploneType: PloneNews.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let ploneItem):
                        let generalItem =  ItemConverter.ploneItemToGeneralItem(item: ploneItem)
                        completion(.success(generalItem))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
            
        case .event:
            api.getPloneItem(user: ploneUser, route: source, ploneType: PloneEvent.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let ploneItem):
                        let generalItem =  ItemConverter.ploneItemToGeneralItem(item: ploneItem)
                        completion(.success(generalItem))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        case .image:
            api.getPloneItem(user: ploneUser, route: source, ploneType: PloneImage.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let ploneItem):
                        let generalItem =  ItemConverter.ploneItemToGeneralItem(item: ploneItem)
                        completion(.success(generalItem))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
            
        case .file:
            api.getPloneItem(user: ploneUser, route: source, ploneType: PloneFile.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let ploneItem):
                        let generalItem =  ItemConverter.ploneItemToGeneralItem(item: ploneItem)
                        completion(.success(generalItem))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
            
        case .link:
            api.getPloneItem(user: ploneUser, route: source, ploneType: PloneLink.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let ploneItem):
                        let generalItem =  ItemConverter.ploneItemToGeneralItem(item: ploneItem)
                        completion(.success(generalItem))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
            
        case .collection:
            api.getPloneItem(user: ploneUser, route: source, ploneType: PloneCollection.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let ploneItem):
                        let generalItem =  ItemConverter.ploneItemToGeneralItem(item: ploneItem)
                        completion(.success(generalItem))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    
}


