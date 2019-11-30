//
//  PloneNewsViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/30.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class PloneNewsViewModel: PloneControllable, RXViewModelType {
    
    typealias PloneContent = PloneNews
    
    let apiManager: APIManager
    var route: URL
    let disposeBag = DisposeBag()
    var ploneItem: PloneContent?
    
    var input: PloneNewsViewModel.Input
    var output: PloneNewsViewModel.Output
       
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
                             showTitle: titleSubject.asDriver(onErrorJustReturn: "Document")
        )
    }
    
    func getPloneData() {
        let user: PloneUser? = StorageManager.shared.loadObject(for: .ploneUser)
        let portalItem = PortalItem.Item<PloneContent>(user: user, route: route)
        let response = apiManager.request(portalItem)
    
        response
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] ploneNews in
        
            self?.ploneItem = ploneNews
            self?.titleSubject.onNext(ploneNews.title)
       
        }) { error in
              print("🚨 Func: \(#file),\(#function)")
              print("Error: \(error)")
        }
        .disposed(by: disposeBag)
    }
    
}
