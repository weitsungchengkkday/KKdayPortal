//
//  GeneralLinkViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class GeneralLinkViewModel: RXViewModelType, PortalControllable {
    
    typealias PortalContent = GeneralItem
    
    var input: GeneralLinkViewModel.Input
    var output: GeneralLinkViewModel.Output
    
    struct Input {
        let title: AnyObserver<String>
    }
    
    struct Output {
        let showTitle: Driver<String>
    }
    
    private let titleSubject = PublishSubject<String>()
    
    var source: URL
    private let disposeBag = DisposeBag()
    var generalItem: PortalContent?
    
    init(source: URL) {
        self.source = source
        
        self.input = Input(title: titleSubject.asObserver()
        )
        
        self.output = Output(showTitle: titleSubject.asDriver(onErrorJustReturn: "Link")
        )
    }
    
    func getPortalData() {
        
        ModelLoader.PortalLoader()
            .getItem(source: source, type: .link)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] generalItem in
                
                self?.generalItem = generalItem
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


