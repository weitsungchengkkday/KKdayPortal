//
//  GeneralCollectionViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/9.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa
import SwiftSoup
import HTMLString

final class GeneralCollectionViewModel: RXViewModelType, PortalControllable {
    
    typealias PortalContent = GeneralItem
    
    var input: GeneralCollectionViewModel.Input
    var output: GeneralCollectionViewModel.Output
    
    struct Input {
        let title: AnyObserver<String>
        let description: AnyObserver<String>
        let generalItems: AnyObserver<[PortalContent]>
        let generalTextObjectItems: AnyObserver<[GeneralTextObjectSection]>
    }
    
    struct Output {
        let showTitle: Driver<String>
        let showDescription: Driver<String>
        let showGeneralItems: Driver<[PortalContent]>
        let showGeneralTextObjectItems: Driver<[GeneralTextObjectSection]>
    }
    
    private let titleSubject = PublishSubject<String>()
    private let descriptionSubject = PublishSubject<String>()
    private let generalItemsSubject = PublishSubject<[PortalContent]>()
    private let generalTextObjectItemsSubject = PublishSubject<[GeneralTextObjectSection]>()
    
    var generalItem: PortalContent?
    var source: URL
    private let disposeBag = DisposeBag()
    
    init(source: URL) {
        self.source = source
        
        self.input = Input(title: titleSubject.asObserver(),
                           description: descriptionSubject.asObserver(), generalItems: generalItemsSubject.asObserver(),
                           generalTextObjectItems: generalTextObjectItemsSubject.asObserver()
        )
        
        self.output = Output(showTitle: titleSubject.asDriver(onErrorJustReturn: "Collection"),
                             showDescription: descriptionSubject.asDriver(onErrorJustReturn: ""), showGeneralItems: generalItemsSubject.asDriver(onErrorJustReturn: []),
                             showGeneralTextObjectItems: generalTextObjectItemsSubject.asDriver(onErrorJustReturn: [])
        )
    }
    
    func getPortalData() {
        
        LoadingManager.shared.setState(state: .normal(value: true))
        
        ModelLoader.PortalLoader().getItem(source: source, type: .collection)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] generalItem in
                
                LoadingManager.shared.setState(state: .normal(value: false))
                
                guard let generalItem = generalItem as? GeneralList else {
                    return
                }
                
                self?.generalItem = generalItem
                if let title = generalItem.title {
                    self?.titleSubject.onNext(title)
                }
                
                if let description = generalItem.description {
                    self?.descriptionSubject.onNext(description)
                }
                
                if let items = generalItem.items {
                    self?.generalItemsSubject.onNext(items)
                }
                
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
