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
        
        guard let config: PortalConfig = StorageManager.shared.loadObject(for: .portalConfig), let portalService = config.data.services.filter({$0.type == "portal" && $0.name == "plone"}).first else {

            print("❌ Can't get plone portal service in portalConfig")
            fatalError()
        }
        
        guard let url = URL(string: portalService.url) else {
            print("❌ Portal URL is invalid")
            fatalError()
        }
        
        return url
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


