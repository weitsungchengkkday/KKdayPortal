//
//  WebPloneRepository.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/7.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class WebPloneRepository: RepositoryManageable {
        
    static var baseURL: URL = URL(string: "http://localhost:8080/pikaPika")!
    
    typealias R = GeneralItem
    
    let apiManager = APIManager.default
    let disposeBag = DisposeBag()
    
    var source: URL
    var user: PloneUser?
    var ploneItemType: PloneItemType
    
    init(source: URL = WebPloneRepository.baseURL, user: PloneUser? = nil, ploneItemType: PloneItemType) {
        self.source = source
        self.user = user
        self.ploneItemType = ploneItemType
    }
    
    func getItem() -> PrimitiveSequence<SingleTrait, R> {
        
        switch ploneItemType {
        case .root:
            let ploneRootRequest = PortalItem.Item<PloneRoot>(user: user, route: source)
            let response = apiManager.request(ploneRootRequest)
           
            return response
                .subscribeOn(MainScheduler.instance)
                .map({ ploneRoot -> GeneralItem in
                    return ItemConverter.ploneItemToGeneralItem(item: ploneRoot)
                })
        case .folder:
             let ploneFolderRequest = PortalItem.Item<PloneFolder>(user: user, route: source)
             let response = apiManager.request(ploneFolderRequest)
             return response
                 .subscribeOn(MainScheduler.instance)
                 .map({ ploneFolder -> GeneralItem in
                     
                     ItemConverter.ploneItemToGeneralItem(item: ploneFolder)
                 })
        case .document:
            let ploneDocumentRequest = PortalItem.Item<PloneDocument>(user: user, route: source)
             let response = apiManager.request(ploneDocumentRequest)
             return response
                 .subscribeOn(MainScheduler.instance)
                 .map({ ploneDocument -> GeneralItem in
                     
                     ItemConverter.ploneItemToGeneralItem(item: ploneDocument)
                 })
        case .news:
             let ploneNewsRequest = PortalItem.Item<PloneNews>(user: user, route: source)
             let response = apiManager.request(ploneNewsRequest)
             return response
                 .subscribeOn(MainScheduler.instance)
                 .map({ ploneNews -> GeneralItem in
                     
                     ItemConverter.ploneItemToGeneralItem(item: ploneNews)
                 })
        case .event:
             let ploneEventRequest = PortalItem.Item<PloneEvent>(user: user, route: source)
             let response = apiManager.request(ploneEventRequest)
             return response
                 .subscribeOn(MainScheduler.instance)
                 .map({ ploneEvent -> GeneralItem in
                     
                     ItemConverter.ploneItemToGeneralItem(item: ploneEvent)
                 })
        case .image:
             let ploneImageRequest = PortalItem.Item<PloneImage>(user: user, route: source)
             let response = apiManager.request(ploneImageRequest)
             return response
                 .subscribeOn(MainScheduler.instance)
                 .map({ ploneImage -> GeneralItem in
                     
                     ItemConverter.ploneItemToGeneralItem(item: ploneImage)
                 })
        case .file:
             let ploneFileRequest = PortalItem.Item<PloneFile>(user: user, route: source)
             let response = apiManager.request(ploneFileRequest)
             return response
                 .subscribeOn(MainScheduler.instance)
                 .map({ ploneFile -> GeneralItem in
                     
                     ItemConverter.ploneItemToGeneralItem(item: ploneFile)
                 })
        case .link:
            let ploneLinkRequest = PortalItem.Item<PloneLink>(user: user, route: source)
             let response = apiManager.request(ploneLinkRequest)
             return response
                 .subscribeOn(MainScheduler.instance)
                 .map({ ploneLink -> GeneralItem in
                     
                     ItemConverter.ploneItemToGeneralItem(item: ploneLink)
                 })
        case .collection:
             let ploneCollectionRequest = PortalItem.Item<PloneCollection>(user: user, route: source)
             let response = apiManager.request(ploneCollectionRequest)
             return response
                 .subscribeOn(MainScheduler.instance)
                 .map({ ploneCollection -> GeneralItem in
                     
                     ItemConverter.ploneItemToGeneralItem(item: ploneCollection)
                 })
        }
        
            
    }
    
    func create(item: R) {}
    func update(item: R) {}
    func delete(item: R) {}
}
