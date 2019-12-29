//
//  GeneralRootViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/7.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class GeneralRootViewModel: RXViewModelType, PortalControllable {
    
    typealias PortalContent = GeneralItem
    
    var input: GeneralRootViewModel.Input
    var output: GeneralRootViewModel.Output
    
    struct Input {
        let generalItems: AnyObserver<[PortalContent]>
        let title: AnyObserver<String>
    }
    
    struct Output {
        let showGeneralItems: Driver<[PortalContent]>
        let showTitle: Driver<String>
    }
    
    private let generalItemsSubject = PublishSubject<[PortalContent]>()
    private let titleSubject = PublishSubject<String>()
    
    var generalItem: PortalContent?
    var source: URL
    private let disposeBag = DisposeBag()
    
    init(source: URL) {
        self.source = source
        
        self.input = Input(generalItems: generalItemsSubject.asObserver(),
                           title: titleSubject.asObserver()
        )
        
        self.output = Output(showGeneralItems: generalItemsSubject.asDriver(onErrorJustReturn: []),
                             showTitle: titleSubject.asDriver(onErrorJustReturn: "Root")
        )
    }
    
    func getPortalData() {
        
        ModelLoader.PortalLoader().getItem(source: source, type: .root)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] generalItem in
                
                guard let generalItem = generalItem as? GeneralList else {
                    return
                }
                
                self?.generalItem = generalItem
                if let items = generalItem.items {
                    self?.generalItemsSubject.onNext(items)
                }
                if let title = generalItem.title {
                    self?.titleSubject.onNext(title)
                }
                
            }) { error in
                print("🚨 Func: \(#file),\(#function)")
                print("Error: \(error)")
        }
        .disposed(by: disposeBag)
    }
    
}