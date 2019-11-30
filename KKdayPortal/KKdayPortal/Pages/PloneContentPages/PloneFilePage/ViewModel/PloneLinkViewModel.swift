//
//  PloneLinkViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/30.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class PloneLinkViewModel : PloneControllable, RXViewModelType {
    
    typealias PloneContent = PloneLink
    
    let apiManager: APIManager
    var route: URL
    let disposeBag = DisposeBag()
    var ploneItem: PloneContent?
    
    var input: PloneLinkViewModel.Input
    var output: PloneLinkViewModel.Output
       
    struct Input {
        let title: AnyObserver<String>
    }
    
    struct Output {
        let showTitle: Driver<String>
    }
    
    private let ploneItemsSubject = PublishSubject<[PloneItem]>()
    private let titleSubject = PublishSubject<String>()
    
    init(apiManager: APIManager, route: URL) {
        self.apiManager = apiManager
        self.route = route
        
        self.input = Input(title: titleSubject.asObserver()
        )
        
        self.output = Output(showTitle: titleSubject.asDriver(onErrorJustReturn: "Link")
        )
    }
    
    func getPloneData() {
        let user: PloneUser? = StorageManager.shared.loadObject(for: .ploneUser)
        let portalItem = PortalItem.Item<PloneContent>(user: user, route: route)
        let response = apiManager.request(portalItem)
    
        response
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] ploneLink in
        
            self?.ploneItem = ploneLink
            self?.titleSubject.onNext(ploneLink.title)
       
        }) { error in
              print("🚨 Func: \(#file),\(#function)")
              print("Error: \(error)")
        }
        .disposed(by: disposeBag)
    }
    
}


