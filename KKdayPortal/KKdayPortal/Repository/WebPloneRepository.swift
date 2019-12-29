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
    
    typealias User = GeneralUser
    typealias Item = GeneralItem
    
    static var baseURL: URL {
        #if SIT_VERSION
          #if DEBUG
          let url = URL(string: "http://localhost:8080/pikaPika")!

          #else
          let url = URL(string: "https://sit.eip.kkday.net/Plone")!
          #endif
          
        #elseif PRODUCTION_VERSION
        let url = URL(string: "https://eip.kkday.net/Plone")!
        #else
        print("Not Implement")
        #endif
      
        return url
    }
    
    private let apiManager = APIManager.default
    private let disposeBag = DisposeBag()
    
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
                                             password: user.password,
                                             token: user.token)
        return ploneUser
    }
    
    init(source: URL = WebPloneRepository.baseURL) {
        self.source = source
    }
    
    func login(account: String, password: String) -> Single<User> {
        
        let signInRequest = PortalUser.Login(account: account, password: password)
        let response = apiManager
            .request(signInRequest)
            .map { ploneAuthToken -> User in
                
                return User(account: account,
                            password: password,
                            token: ploneAuthToken.token)
        }
        return response
    }
    
    func renewToken() -> Single<User?> {
        
        let renewGeneralUser: User? = user
        let renewPloneUser: PloneUser? = ploneUser
        
        let renewTokenRequest = PortalUser.RenewToken(user: renewPloneUser)
        let response = apiManager.request(renewTokenRequest)
            .map { ploneAuthToken -> User? in
                
                guard let renewGeneralUser = renewGeneralUser else {
                    return nil
                }
                
                return User(account: renewGeneralUser.account,
                            password: renewGeneralUser.password,
                            token: ploneAuthToken.token)
        }
        
        return response
    }
    
    func logout() -> Single<User> {
       
        let logoutGeneralUser: User? = user
        
        return Single<User>.create { single -> Disposable in
            if let logoutGeneralUser = logoutGeneralUser {
                StorageManager.shared.remove(for: .generalUser)
                single(.success(logoutGeneralUser))
            } else {
                single(.error(AccountOperatingError.UserNonExisting))
            }
            
            return Disposables.create()
        }
    }
    
    func getItem(generalItemType: GeneralItemType) -> Single<Item> {
        
        let ploneItemType = ItemConverter.typeTransfer(generalItemType: generalItemType)
      
        switch ploneItemType {
        case .root:
            let ploneRootRequest = PortalItem.Item<PloneRoot>(user: ploneUser, route: source)
            let response = apiManager.request(ploneRootRequest)
            return response
                .map({ ploneRoot -> GeneralItem in
                    return ItemConverter.ploneItemToGeneralItem(item: ploneRoot)
                })
            
        case .folder:
            let ploneFolderRequest = PortalItem.Item<PloneFolder>(user: ploneUser, route: source)
            let response = apiManager.request(ploneFolderRequest)
            return response
                .map({ ploneFolder -> GeneralItem in
                    ItemConverter.ploneItemToGeneralItem(item: ploneFolder)
                })
            
        case .document:
            let ploneDocumentRequest = PortalItem.Item<PloneDocument>(user: ploneUser, route: source)
            let response = apiManager.request(ploneDocumentRequest)
            return response
                .map({ ploneDocument -> GeneralItem in
                    ItemConverter.ploneItemToGeneralItem(item: ploneDocument)
                })
            
        case .news:
            let ploneNewsRequest = PortalItem.Item<PloneNews>(user: ploneUser, route: source)
            let response = apiManager.request(ploneNewsRequest)
            return response
                .map({ ploneNews -> GeneralItem in
                    ItemConverter.ploneItemToGeneralItem(item: ploneNews)
                })
            
        case .event:
            let ploneEventRequest = PortalItem.Item<PloneEvent>(user: ploneUser, route: source)
            let response = apiManager.request(ploneEventRequest)
            return response
                .map({ ploneEvent -> GeneralItem in
                    ItemConverter.ploneItemToGeneralItem(item: ploneEvent)
                })
            
        case .image:
            let ploneImageRequest = PortalItem.Item<PloneImage>(user: ploneUser, route: source)
            let response = apiManager.request(ploneImageRequest)
            return response
                .map({ ploneImage -> GeneralItem in
                    ItemConverter.ploneItemToGeneralItem(item: ploneImage)
                })
            
        case .file:
            let ploneFileRequest = PortalItem.Item<PloneFile>(user: ploneUser, route: source)
            let response = apiManager.request(ploneFileRequest)
            return response
                .map({ ploneFile -> GeneralItem in
                    ItemConverter.ploneItemToGeneralItem(item: ploneFile)
                })
            
        case .link:
            let ploneLinkRequest = PortalItem.Item<PloneLink>(user: ploneUser, route: source)
            let response = apiManager.request(ploneLinkRequest)
            return response
                .map({ ploneLink -> GeneralItem in
                    ItemConverter.ploneItemToGeneralItem(item: ploneLink)
                })
            
        case .collection:
            let ploneCollectionRequest = PortalItem.Item<PloneCollection>(user: ploneUser, route: source)
            let response = apiManager.request(ploneCollectionRequest)
            return response
                .map({ ploneCollection -> GeneralItem in
                    ItemConverter.ploneItemToGeneralItem(item: ploneCollection)
                })
        }
    }
    
    func create() {}
    func update(item: Item) {}
    func delete(item: Item) {}
}
