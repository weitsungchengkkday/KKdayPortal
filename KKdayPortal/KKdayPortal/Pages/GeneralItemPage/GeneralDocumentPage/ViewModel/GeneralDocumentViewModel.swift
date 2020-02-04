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
        let generalTextObjectItems: AnyObserver<[GeneralTextObjectSection]>
    }
    
    struct Output {
        let showTitle: Driver<String>
        let showGeneralTextObjectItems: Driver<[GeneralTextObjectSection]>
    }
    
    private let titleSubject = PublishSubject<String>()
    private let generalTextObjectItemsSubject = PublishSubject<[GeneralTextObjectSection]>()
    
    var source: URL
    private let disposeBag = DisposeBag()
    var generalItem: PortalContent?
    
    init(source: URL) {
        
        self.source = source
        self.input = Input(title: titleSubject.asObserver(), generalTextObjectItems: generalTextObjectItemsSubject.asObserver())
        self.output = Output(showTitle: titleSubject.asDriver(onErrorJustReturn: "Document"), showGeneralTextObjectItems: generalTextObjectItemsSubject.asDriver(onErrorJustReturn: []))
    }
    
    func getPortalData() {
        
        LoadingManager.shared.setState(state: .normal(value: true))
        
        ModelLoader.PortalLoader()
            .getItem(source: source, type: .document)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] generalItem in
                
                LoadingManager.shared.setState(state: .normal(value: false))
                
                self?.generalItem = generalItem
                if let title = generalItem.title {
                    self?.titleSubject.onNext(title)
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
