//
//  GeneralIndexSideBarViewModel.swift
//  KKdayPortal-Sit
//
//  Created by WEI-TSUNG CHENG on 2020/1/9.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class GeneralIndexSideBarViewModel: RXViewModelType  {
    
    typealias PortalContent = GeneralItem
    
    var input: GeneralIndexSideBarViewModel.Input
    var output: GeneralIndexSideBarViewModel.Output
    
    struct Input {
        let generalItems: AnyObserver<[PortalContent]>
    }
    
    struct Output {
        let showGeneralItems: Driver<[PortalContent]>
    }
    
    private let generalItemsSubject = PublishSubject<[PortalContent]>()
    
    var generalItem: PortalContent?
    var contents: [PortalContent]
    private let disposeBag = DisposeBag()
    
    init(contents: [PortalContent]) {
        self.contents = contents
        
        self.input = Input(generalItems: generalItemsSubject.asObserver())
        
        self.output = Output(showGeneralItems: generalItemsSubject.asDriver(onErrorJustReturn: []))
    }
    
    func loadPortalContent() {
        generalItemsSubject.onNext(contents)
    }
    
}
