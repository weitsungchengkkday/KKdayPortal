//
//  GeneralDocumentViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class GeneralDocumentViewModel: RXViewModelType, PortalControllable {
    
    typealias PortalContent = GeneralItem
    
    var input: GeneralDocumentViewModel.Input
    var output: GeneralDocumentViewModel.Output
       
    struct Input {
        let title: AnyObserver<String>
        let text: AnyObserver<String>
    }
    
    struct Output {
        let showTitle: Driver<String>
        let showText: Driver<String>
    }
    
    private let titleSubject = PublishSubject<String>()
    private let textSubject = PublishSubject<String>()
    
    var source: URL
    let disposeBag = DisposeBag()
    var generalItem: PortalContent?
    
    init(source: URL) {

        self.source = source
        self.input = Input(title: titleSubject.asObserver(), text: textSubject.asObserver())
        self.output = Output(showTitle: titleSubject.asDriver(onErrorJustReturn: "Document"), showText: textSubject.asDriver(onErrorJustReturn: "No available info"))
    }
    
    func getPortalData() {
        
        let user: PloneUser? = StorageManager.shared.loadObject(for: .ploneUser)
        
        ModelLoader.PortalItem().getItem(repo: WebPloneRepository(source: source, user: user, ploneItemType: .document))
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] generalItem in
                
                self?.generalItem = generalItem
                if let title = generalItem.title {
                    self?.titleSubject.onNext(title)
                }
                
                guard let textObject = generalItem.textObject,
                    let text = textObject.text else {
                    return
                }
                self?.textSubject.onNext(text)
                
            }) { error in
                print("🚨 Func: \(#file),\(#function)")
                print("Error: \(error)")
        }
        .disposed(by: disposeBag)
    }
    
    
}
