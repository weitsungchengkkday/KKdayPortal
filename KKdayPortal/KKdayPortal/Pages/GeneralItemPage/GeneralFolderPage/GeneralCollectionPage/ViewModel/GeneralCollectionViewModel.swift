//
//  GeneralCollectionViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/9.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class GeneralCollectionViewModel: RXViewModelType, PortalControllable {
    
    typealias PortalContent = GeneralItem
    
    var input: GeneralCollectionViewModel.Input
    var output: GeneralCollectionViewModel.Output
    
    struct Input {
        let generalItems: AnyObserver<[PortalContent]>
        let generalText: AnyObserver<GeneralTextObject>
        let title: AnyObserver<String>
    }
    
    struct Output {
        let showGeneralItems: Driver<[PortalContent]>
        let showGeneralText: Driver<GeneralTextObject>
        let showTitle: Driver<String>
    }
    
    private let generalItemsSubject = PublishSubject<[PortalContent]>()
    private let generalTextSubject = PublishSubject<GeneralTextObject>()
    private let titleSubject = PublishSubject<String>()
    
    var generalItem: PortalContent?
    var source: URL
    private let disposeBag = DisposeBag()
    
    init(source: URL) {
        self.source = source
        
        self.input = Input(generalItems: generalItemsSubject.asObserver(),
                           generalText: generalTextSubject.asObserver(),
                           title: titleSubject.asObserver()
        )
        
        self.output = Output(showGeneralItems: generalItemsSubject.asDriver(onErrorJustReturn: []),
                             showGeneralText: generalTextSubject.asDriver(onErrorJustReturn: GeneralTextObject(contentType: nil, name: "", text: nil)),
                             showTitle: titleSubject.asDriver(onErrorJustReturn: "Collection")
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
                if let items = generalItem.items {
                    self?.generalItemsSubject.onNext(items)
                }
                
                if let textOnbject = self?.generalItem?.textObject {
                    self?.generalTextSubject.onNext(textOnbject)
                }
                
                if let title = generalItem.title {
                    self?.titleSubject.onNext(title)
                }
                
            }) { error in
                
                LoadingManager.shared.setState(state: .normal(value: false))
                
                print("🚨 Func: \(#file),\(#function)")
                print("Error: \(error)")
        }
        .disposed(by: disposeBag)
    }
    
}
