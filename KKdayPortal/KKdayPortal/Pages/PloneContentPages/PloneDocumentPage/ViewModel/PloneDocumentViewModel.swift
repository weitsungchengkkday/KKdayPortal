//
//  PloneDocumentViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/30.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class PloneDocumentViewModel: PloneControllable, RXViewModelType {
    
    typealias PloneContent = PloneDocument
    
    let apiManager: APIManager
    var route: URL
    let disposeBag = DisposeBag()
    var ploneItem: PloneDocument?
    
    var input: PloneDocumentViewModel.Input
    var output: PloneDocumentViewModel.Output
       
    struct Input {
        let title: AnyObserver<String>
        let dataText: AnyObserver<String>
    }
    
    struct Output {
        let showTitle: Driver<String>
        let showDataText: Driver<String>
    }
    
    private let ploneItemsSubject = PublishSubject<[PloneItem]>()
    private let titleSubject = PublishSubject<String>()
    private let dataTextSubject = PublishSubject<String>()
    
    init(apiManager: APIManager, route: URL) {
        self.apiManager = apiManager
        self.route = route
        self.input = Input(title: titleSubject.asObserver(), dataText: dataTextSubject.asObserver())
        self.output = Output(showTitle: titleSubject.asDriver(onErrorJustReturn: "Document"), showDataText: dataTextSubject.asDriver(onErrorJustReturn: "No available info"))
    }
    
    func getPloneData() {
        let user: PloneUser? = StorageManager.shared.loadObject(for: .ploneUser)
        let portalItem = PortalItem.Item<PloneContent>(user: user, route: route)
        let response = apiManager.request(portalItem)
        
        response
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] ploneDocument in
                
                self?.ploneItem = ploneDocument
                if let title = ploneDocument.title {
                    self?.titleSubject.onNext(title)
                }
                
                guard let text = ploneDocument.text else {
                    return
                }
                self?.dataTextSubject.onNext(text.data)
                
            }) { error in
                print("🚨 Func: \(#file),\(#function)")
                print("Error: \(error)")
        }
        .disposed(by: disposeBag)
    }
    
}



