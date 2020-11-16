//
//  GeneralRootWithLanguageViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/8.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa
import DolphinHTTP

final class GeneralRootWithLanguageDocumentViewModel: ViewModelType {
    
    typealias PortalContent = GeneralItem
    typealias PortalContentList = GeneralList
    
    var input: GeneralRootWithLanguageDocumentViewModel.Input
    var output: GeneralRootWithLanguageDocumentViewModel.Output
    
    struct Input {
        let documentTitle: AnyObserver<String>
        let documentDescription: AnyObserver<String>
        let documentGeneralTextObjectItems: AnyObserver<[GeneralTextObjectSection]>
    }
    
    struct Output {
        let showDocumentTitle: Driver<String>
        let showDocumentDescription: Driver<String>
        let showDocumentGeneralTextObjectItems: Driver<[GeneralTextObjectSection]>
    }
    
    private let documentTitleSubject = PublishSubject<String>()
    private let documentDescriptionSubject = PublishSubject<String>()
    private let documentGeneralTextObjectItemsSubject = PublishSubject<[GeneralTextObjectSection]>()
    
    var generalItem: PortalContentList?
    var generalItemDocument: PortalContent?
    
    var source: URL
    private let disposeBag = DisposeBag()
    
    init(source: URL) {
        self.source = source
        
        self.input = Input(documentTitle: documentTitleSubject.asObserver(), documentDescription: documentDescriptionSubject.asObserver(), documentGeneralTextObjectItems: documentGeneralTextObjectItemsSubject.asObserver()
        )
        
        self.output = Output(showDocumentTitle: documentTitleSubject.asDriver(onErrorJustReturn: ""), showDocumentDescription: documentDescriptionSubject.asDriver(onErrorJustReturn: ""), showDocumentGeneralTextObjectItems: documentGeneralTextObjectItemsSubject.asDriver(onErrorJustReturn: []))
    }
    
    
    func loadPortalData() {
        LoadingManager.shared.setState(state: .normal(value: true))
        
        ModelLoader.PortalLoader()
            .loadItem(source: source, type: .root_with_language) { [weak self] result in
                
                switch result {
                case .success(let generalItem):
                    
                    LoadingManager.shared.setState(state: .normal(value: false))
                    
                    guard let generalItem = generalItem as? GeneralList else {
                        return
                    }
                    
                    self?.generalItem = generalItem
                    
                    if let items = generalItem.items {
                        let documentItem = items.filter ({ $0.type == .document })
                        
                        self?.generalItemDocument = documentItem.first
                    }
                    self?.loadPortalDocumentData()
                    
                case .failure(let error):
                    
                    print("🚨 Func: \(#file),\(#function)")
                    print("Error: \(error)")
                    LoadingManager.shared.setState(state: .normal(value: false))
                }
            }
    }
    
    private func loadPortalDocumentData() {
        guard let source = generalItemDocument?.source else {
            return
        }
        
        ModelLoader.PortalLoader()
            .loadItem(source: source, type: .document) { [weak self] result in
                
                LoadingManager.shared.setState(state: .normal(value: true))
                
                switch result {
                case .success(let generalItem):
                    LoadingManager.shared.setState(state: .normal(value: false))
                    
                    if let generalItemSource = generalItem.source,
                        let generalItemDocumentSource = self?.generalItemDocument?.source,
                        generalItemSource == generalItemDocumentSource {
                        
                        self?.generalItemDocument = generalItem
                        
                        if let title = generalItem.title {
                            self?.documentTitleSubject.onNext(title)
                        }
                        
                        if let description = generalItem.description {
                            self?.documentDescriptionSubject.onNext(description)
                        }
                        
                        if let textObject = generalItem.textObject {
                            
                            let generalTextObjectSections = GeneralTextObjectConverter.generalTextObjectToGeneralTextObjectSectionArray(textObject: textObject)
                            self?.documentGeneralTextObjectItemsSubject.onNext(generalTextObjectSections)
                        }
                    }
                case .failure(let error):
                    print("🚨 Func: \(#file),\(#function)")
                    print("Error: \(error)")
                    
                    LoadingManager.shared.setState(state: .normal(value: false))
            }
        }
        
    }
    
//    func getPortalData() {
//
//        LoadingManager.shared.setState(state: .normal(value: true))
//
//        ModelLoader.PortalLoader()
//            .getItem(source: source, type: .root_with_language)
//            .subscribeOn(MainScheduler.instance)
//            .subscribe(onSuccess: { [weak self] generalItem in
//
//                LoadingManager.shared.setState(state: .normal(value: false))
//
//                guard let generalItem = generalItem as? GeneralList else {
//                    return
//                }
//
//                self?.generalItem = generalItem
//
//                if let items = generalItem.items {
//                    let documentItem = items.filter ({ $0.type == .document })
//
//                    self?.generalItemDocument = documentItem.first
//                }
//                self?.getPortalDocumentData()
//
//            }) { error in
//                print("🚨 Func: \(#file),\(#function)")
//                print("Error: \(error)")
//
//                LoadingManager.shared.setState(state: .normal(value: false))
//        }
//        .disposed(by: disposeBag)
//    }
    
//    private func getPortalDocumentData() {
//
//        guard let source = generalItemDocument?.source else {
//            return
//        }
//
//        LoadingManager.shared.setState(state: .normal(value: true))
//
//        ModelLoader.PortalLoader()
//            .getItem(source: source, type: .document)
//            .subscribeOn(MainScheduler.instance)
//            .subscribe(onSuccess: { [weak self] generalItem in
//
//                LoadingManager.shared.setState(state: .normal(value: false))
//
//                if let generalItemSource = generalItem.source,
//                    let generalItemDocumentSource = self?.generalItemDocument?.source,
//                    generalItemSource == generalItemDocumentSource {
//
//                    self?.generalItemDocument = generalItem
//
//                    if let title = generalItem.title {
//                        self?.documentTitleSubject.onNext(title)
//                    }
//
//                    if let description = generalItem.description {
//                        self?.documentDescriptionSubject.onNext(description)
//                    }
//
//                    if let textObject = generalItem.textObject {
//
//                        let generalTextObjectSections = GeneralTextObjectConverter.generalTextObjectToGeneralTextObjectSectionArray(textObject: textObject)
//                        self?.documentGeneralTextObjectItemsSubject.onNext(generalTextObjectSections)
//                    }
//                }
//
//            }) { error in
//                print("🚨 Func: \(#file),\(#function)")
//                print("Error: \(error)")
//
//                LoadingManager.shared.setState(state: .normal(value: false))
//        }
//        .disposed(by: disposeBag)
//    }
}
