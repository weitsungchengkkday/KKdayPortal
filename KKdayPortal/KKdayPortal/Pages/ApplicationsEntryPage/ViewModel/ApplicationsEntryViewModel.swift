//
//  ApplicationsEntryViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/18.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class ApplicationsEntryViewModel: RXViewModelType, PortalControllable {
    
    typealias PortalContent = GeneralItem
    
    var input: ApplicationsEntryViewModel.Input
    var output: ApplicationsEntryViewModel.Output
    
    struct Input {
        let generalItems: AnyObserver<[PortalContent]>
        let title: AnyObserver<String>
        let isLoading: AnyObserver<Bool>
    }
    
    struct Output {
        let showGeneralItems: Driver<[PortalContent]>
        let showTitle: Driver<String>
        let showIsLoading: Driver<Bool>
    }
    
    private let generalItemsSubject = PublishSubject<[PortalContent]>()
    private let isLoadingSubject = PublishSubject<Bool>()
    private let titleSubject = PublishSubject<String>()
    
    var generalItem: PortalContent?
    var source: URL
    let disposeBag = DisposeBag()
    
    init(source: URL) {
        self.source = source
        
        self.input = Input(generalItems: generalItemsSubject.asObserver()
            , title: titleSubject.asObserver(),
                           isLoading: isLoadingSubject.asObserver())
        
        self.output = Output(showGeneralItems: generalItemsSubject.asDriver(onErrorJustReturn: []),
                             showTitle: titleSubject.asDriver(onErrorJustReturn: "Applications"),
                             showIsLoading: isLoadingSubject.asDriver(onErrorJustReturn: false))
    }
    
    func getPortalData() {
        
        isLoadingSubject.onNext(true)
        
        ModelLoader.PortalLoader().getItem(source: source, type: .folder)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] generalItem in
                
                self?.isLoadingSubject.onNext(false)
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
                
            }) { [weak self] error in
                
                self?.isLoadingSubject.onNext(false)
                print("🚨 Func: \(#file),\(#function)")
                print("Error: \(error)")
        }
        .disposed(by: disposeBag)
    }
    
}
