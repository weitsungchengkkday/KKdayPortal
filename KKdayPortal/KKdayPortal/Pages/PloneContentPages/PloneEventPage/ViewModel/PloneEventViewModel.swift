//
//  PloneEventViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/30.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class PloneEventViewModel: PloneControllable, RXViewModelType {
    
    typealias PloneContent = PloneEvent
    
    let apiManager: APIManager
    var route: URL
    let disposeBag = DisposeBag()
    var ploneItem: PloneContent?
    
    var input: PloneEventViewModel.Input
    var output: PloneEventViewModel.Output
       
    struct Input {
        let title: AnyObserver<String>
        let contact: AnyObserver<String>
        let event: AnyObserver<String>
        let dataText: AnyObserver<String>
    }
    
    struct Output {
        let showTitle: Driver<String>
        let showContact: Driver<String>
        let showEvent: Driver<String>
        let showDataText: Driver<String>
    }
    
    private let titleSubject = PublishSubject<String>()
    private let contactSubject = PublishSubject<String>()
    private let eventSubject = PublishSubject<String>()
    private let dataTextSubject = PublishSubject<String>()
    
    init(apiManager: APIManager, route: URL) {
        self.apiManager = apiManager
        self.route = route
        self.input = Input(title: titleSubject.asObserver(), contact: contactSubject.asObserver(), event: eventSubject.asObserver(), dataText: dataTextSubject.asObserver())
        self.output = Output(showTitle: titleSubject.asDriver(onErrorJustReturn: "Event"), showContact: contactSubject.asDriver(onErrorJustReturn: ""), showEvent: eventSubject.asDriver(onErrorJustReturn: ""), showDataText: dataTextSubject.asDriver(onErrorJustReturn: "")
        )
    }
    
    func getPloneData() {
        let user: PloneUser? = StorageManager.shared.loadObject(for: .ploneUser)
        let portalItem = PortalItem.Item<PloneContent>(user: user, route: route)
        let response = apiManager.request(portalItem)
        
        response
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] ploneEvent in
                
                self?.ploneItem = ploneEvent
                if let title = ploneEvent.title {
                    self?.titleSubject.onNext(title)
                }
                
                let contactInfo = """
                contactName: \(ploneEvent.contactName ?? "No Info")
                contactEmail: \(ploneEvent.contactEmail ?? "No Info")
                contactPhone: \(ploneEvent.contactPhone ?? "No Info")
                """
                self?.contactSubject.onNext(contactInfo)
                
                let eventInfo = """
                createDate: \(ploneEvent.createDate?.description ?? "No Info")
                startDate: \(ploneEvent.startDate?.description ?? "No Info")
                endDate: \(ploneEvent.endDate?.description ?? "No Info")
                location: \(ploneEvent.location ?? "No Info")
                eventURL: \(ploneEvent.eventURL?.absoluteString ?? "No Info")
                """
                
                self?.eventSubject.onNext(eventInfo)
                if let text = ploneEvent.text {
                    self?.dataTextSubject.onNext(text.data)
                }
                
            }) { error in
                print("🚨 Func: \(#file),\(#function)")
                print("Error: \(error)")
        }
        .disposed(by: disposeBag)
    }
    
}


