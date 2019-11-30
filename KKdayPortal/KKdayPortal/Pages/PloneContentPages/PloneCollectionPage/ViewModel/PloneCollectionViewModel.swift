//
//  PloneCollectionViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/30.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class PloneCollectionViewModel: PloneControllable, RXViewModelType {
    
    typealias PloneContent = PloneCollection
    
    let apiManager: APIManager
    var route: URL
    let disposeBag = DisposeBag()
    var ploneItem: PloneContent?
    
    var input: PloneCollectionViewModel.Input
    var output: PloneCollectionViewModel.Output
       
    struct Input {
        let ploneItems: AnyObserver<[PloneItem]>
        let title: AnyObserver<String>
    }
    
    struct Output {
        let showPloneItems: Driver<[PloneItem]>
        let showTitle: Driver<String>
    }
    
    private let ploneItemsSubject = PublishSubject<[PloneItem]>()
    private let titleSubject = PublishSubject<String>()
    
    init(apiManager: APIManager, route: URL) {
        self.apiManager = apiManager
        self.route = route
        
        self.input = Input(ploneItems: ploneItemsSubject.asObserver(),
                           title: titleSubject.asObserver()
        )
        
        self.output = Output(showPloneItems: ploneItemsSubject.asDriver(onErrorJustReturn: []),
                             showTitle: titleSubject.asDriver(onErrorJustReturn: "Folder")
        )
    }
    
    func getPloneData() {
        let user: PloneUser? = StorageManager.shared.loadObject(for: .ploneUser)
        let portalItem = PortalItem.Item<PloneContent>(user: user, route: route)
        let response = apiManager.request(portalItem)
    
        response.subscribe(onSuccess: { [weak self] ploneFolder in
        
            self?.ploneItem = ploneFolder
            self?.ploneItemsSubject.onNext(ploneFolder.items)
            self?.titleSubject.onNext(ploneFolder.title)
       
        }) { error in
              print("🚨 Func: \(#file),\(#function)")
              print("Error: \(error)")
        }
        .disposed(by: disposeBag)
    }
    
}



