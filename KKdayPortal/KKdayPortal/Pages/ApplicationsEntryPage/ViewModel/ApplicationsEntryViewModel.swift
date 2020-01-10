//
//  ApplicationsEntryViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/18.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class ApplicationsEntryViewModel: RXViewModelType {
    
    typealias PortalContent = GeneralItem
    
    var input: ApplicationsEntryViewModel.Input
    var output: ApplicationsEntryViewModel.Output
    
    struct Input {
        let generalItemsURL: AnyObserver<[URL]>
        let isLoading: AnyObserver<Bool>
    }
    
    struct Output {
        let showGeneralItemsURL: Driver<[URL]>
        let showIsLoading: Driver<Bool>
    }
    
    private let generalItemsURLSubject = PublishSubject<[URL]>()
    private let isLoadingSubject = PublishSubject<Bool>()
    
    var generalItemsURL: [URL] = [URL(string: "https://sit.eip.kkday.net/Plone/zh-tw/02-all-services/bpm")!]
    
    let disposeBag = DisposeBag()
    
    init() {
        self.input = Input(generalItemsURL: generalItemsURLSubject.asObserver()
            , isLoading: isLoadingSubject.asObserver())
        
        self.output = Output(showGeneralItemsURL: generalItemsURLSubject.asDriver(onErrorJustReturn: []),
                             showIsLoading: isLoadingSubject.asDriver(onErrorJustReturn: false))
    }
    
    func getPortalData() {
        generalItemsURLSubject.onNext(generalItemsURL)
    }
    
}
