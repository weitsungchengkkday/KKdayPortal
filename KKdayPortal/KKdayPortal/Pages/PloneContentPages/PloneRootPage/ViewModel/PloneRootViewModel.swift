//
//  PloneRootViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/28.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class PloneRootViewModel: PloneControllable, RXViewModelType {

    typealias PloneContent = PloneRoot
    let apiManager: APIManager
    var route: URL
    let disposeBag = DisposeBag()
    var ploneItem: PloneContent?
    
    var input: PloneRootViewModel.Input
    var output: PloneRootViewModel.Output
   
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
                             showTitle: titleSubject.asDriver(onErrorJustReturn: "Root")
        )
    }
    
    func getPloneData() {
        let user: PloneUser? = StorageManager.shared.loadObject(for: .ploneUser)
        let portalItem = PortalItem.Item<PloneContent>(user: user, route: route)
        let response = apiManager.request(portalItem)
        
        response
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] ploneRoot in
            self?.ploneItem = ploneRoot
            self?.ploneItemsSubject.onNext(ploneRoot.items)
            self?.titleSubject.onNext(ploneRoot.title)
            
        }) { error in
            print("🚨 Func: \(#file),\(#function)")
            print("Error: \(error)")
        }
        .disposed(by: disposeBag)
     }

     
    
}
