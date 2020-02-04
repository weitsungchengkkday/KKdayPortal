//
//  GeneralEventViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class GeneralEventViewModel: RXViewModelType, PortalControllable {
    
    typealias PortalContent = GeneralItem
    
    var input: GeneralEventViewModel.Input
    var output: GeneralEventViewModel.Output
    
    struct Input {
        let title: AnyObserver<String>
        let contact: AnyObserver<String>
        let event: AnyObserver<String>
        let generalTextObjectItems: AnyObserver<[GeneralTextObjectSection]>
    }
    
    struct Output {
        let showTitle: Driver<String>
        let showContact: Driver<String>
        let showEvent: Driver<String>
        let showGeneralTextObjectItems: Driver<[GeneralTextObjectSection]>
    }
    
    private let titleSubject = PublishSubject<String>()
    private let contactSubject = PublishSubject<String>()
    private let eventSubject = PublishSubject<String>()
    private let generalTextObjectItemsSubject = PublishSubject<[GeneralTextObjectSection]>()
    
    var source: URL
    private let disposeBag = DisposeBag()
    var generalItem: PortalContent?
    
    init(source: URL) {
        
        self.source = source
        self.input = Input(title: titleSubject.asObserver(), contact: contactSubject.asObserver(), event: eventSubject.asObserver(), generalTextObjectItems: generalTextObjectItemsSubject.asObserver())
        self.output = Output(showTitle: titleSubject.asDriver(onErrorJustReturn: "Event"), showContact: contactSubject.asDriver(onErrorJustReturn: ""), showEvent: eventSubject.asDriver(onErrorJustReturn: ""), showGeneralTextObjectItems: generalTextObjectItemsSubject.asDriver(onErrorJustReturn: [])
        )
    }
    
    func getPortalData() {
        
        LoadingManager.shared.setState(state: .normal(value: true))
        
        ModelLoader.PortalLoader()
            .getItem(source: source, type: .event)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] generalItem in
                
                LoadingManager.shared.setState(state: .normal(value: false))
                
                self?.generalItem = generalItem
                if let title = generalItem.title {
                    self?.titleSubject.onNext(title)
                }
                
                let contactInfo = """
                contactName: \(generalItem.eventObject?.contactName ?? "No Info")
                contactEmail: \(generalItem.eventObject?.contactEmail ?? "No Info")
                contactPhone: \(generalItem.eventObject?.contactPhone ?? "No Info")
                """
                self?.contactSubject.onNext(contactInfo)
                
                let eventInfo = """
                createDate: \(generalItem.eventObject?.createDate?.description ?? "No Info")
                startDate: \(generalItem.eventObject?.startDate?.description ?? "No Info")
                endDate: \(generalItem.eventObject?.endDate?.description ?? "No Info")
                location: \(generalItem.eventObject?.location ?? "No Info")
                eventURL: \(generalItem.eventObject?.eventURL?.absoluteString ?? "No Info")
                """
                
                self?.eventSubject.onNext(eventInfo)
                if let textObject = generalItem.textObject {
                 
                    let generalTextObjectSections = GeneralTextObjectConverter.generalTextObjectToGeneralTextObjectSectionArray(textObject: textObject)
                    self?.generalTextObjectItemsSubject.onNext(generalTextObjectSections)
                }
                
            }) { error in
                
                LoadingManager.shared.setState(state: .normal(value: false))
                
                print("🚨 Func: \(#file),\(#function)")
                print("Error: \(error)")
        }
        .disposed(by: disposeBag)
    }
    
}



