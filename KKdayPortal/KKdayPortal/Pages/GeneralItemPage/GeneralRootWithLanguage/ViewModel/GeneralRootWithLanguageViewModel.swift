//
//  GeneralRootWithLanguageViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/8.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class GeneralRootWithLanguageViewModel: RXViewModelType {
    
    typealias PortalContent = GeneralItem
    typealias PortalContentList = GeneralList
    
    var input: GeneralRootWithLanguageViewModel.Input
    var output: GeneralRootWithLanguageViewModel.Output
    
    struct Input {
        let generalItems: AnyObserver<[PortalContentList]>
        let documentTitle: AnyObserver<String>
        let documentDescription: AnyObserver<String>
        let documentGeneralTextObjectItems: AnyObserver<[GeneralTextObjectSection]>
    }
    
    struct Output {
        let showGeneralItems: Driver<[PortalContentList]>
        let showDocumentTitle: Driver<String>
        let showDocumentDescription: Driver<String>
        let showDocumentGeneralTextObjectItems: Driver<[GeneralTextObjectSection]>
    }
    
    private let generalItemsSubject = PublishSubject<[PortalContentList]>()
    private let documentTitleSubject = PublishSubject<String>()
    private let documentDescriptionSubject = PublishSubject<String>()
    private let documentGeneralTextObjectItemsSubject = PublishSubject<[GeneralTextObjectSection]>()
    
    var generalItem: PortalContentList?
    
    var generalItemDocument: PortalContent?
    var generalItemFolders: [PortalContentList] = []
    
    var source: URL
    private let disposeBag = DisposeBag()
    
    init(source: URL) {
        self.source = source
        
        self.input = Input(generalItems: generalItemsSubject.asObserver(), documentTitle: documentTitleSubject.asObserver(), documentDescription: documentDescriptionSubject.asObserver(), documentGeneralTextObjectItems: documentGeneralTextObjectItemsSubject.asObserver()
        )
        
        self.output = Output(showGeneralItems: generalItemsSubject.asDriver(onErrorJustReturn: []), showDocumentTitle: documentTitleSubject.asDriver(onErrorJustReturn: ""), showDocumentDescription: documentDescriptionSubject.asDriver(onErrorJustReturn: ""), showDocumentGeneralTextObjectItems: documentGeneralTextObjectItemsSubject.asDriver(onErrorJustReturn: []))
    }
    
    func getPortalData() {
        
        LoadingManager.shared.setState(state: .normal(value: true))
        
        ModelLoader.PortalLoader().getItem(source: source, type: .root_with_language)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] generalItem in
                
                LoadingManager.shared.setState(state: .normal(value: false))
                
                guard let generalItem = generalItem as? GeneralList else {
                    return
                }
                
                self?.generalItem = generalItem
                
                if let items = generalItem.items {
                    // Document
                    let documentItem = items.filter ({ $0.type == .document })
                    
                    self?.generalItemDocument = documentItem.first
                    
                    // Folders
                    let foldersItems = items
                        .filter({ $0.type == .folder })
                        .map { generalItem -> GeneralList in
                            
                            return GeneralList(type: generalItem.type,
                                               title: generalItem.title,
                                               description: generalItem.title,
                                               parent: generalItem.parent,
                                               id: generalItem.id,
                                               UID: generalItem.UID,
                                               source: generalItem.source,
                                               imageObject: generalItem.imageObject,
                                               textObject: generalItem.textObject,
                                               eventObject: generalItem.eventObject,
                                               fileObject: generalItem.fileObject,
                                               linkObject: generalItem.linkObject,
                                               items: nil)
                    }
                    self?.generalItemFolders  = foldersItems
                }
                
                // Get Detail Info
                self?.getPortalDocumentData()
                self?.getPortalFoldersData()
                
            }) { error in
                print("🚨 Func: \(#file),\(#function)")
                print("Error: \(error)")
                
                LoadingManager.shared.setState(state: .normal(value: false))
        }
        .disposed(by: disposeBag)
    }
    
    private func getPortalDocumentData() {
        
        guard let source = generalItemDocument?.source else {
            return
        }
        
        LoadingManager.shared.setState(state: .normal(value: true))
        
        ModelLoader.PortalLoader().getItem(source: source, type: .document)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] generalItem in
                
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
                
            }) { error in
                print("🚨 Func: \(#file),\(#function)")
                print("Error: \(error)")
                
                LoadingManager.shared.setState(state: .normal(value: false))
        }
        .disposed(by: disposeBag)
    }
    
    
    
    private func getPortalFoldersData() {
        
        var generalItemObservables: [Observable<GeneralItem>] = []
        
        for folder in generalItemFolders {
            if let source = folder.source {
                let generalItemObservable = ModelLoader.PortalLoader().getItem(source: source, type: .folder).asObservable()
                generalItemObservables.append(generalItemObservable)
            }
        }
        
        LoadingManager.shared.setState(state: .normal(value: true))
        
        Observable.combineLatest(generalItemObservables)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] generalItems in
                
                let generalList =  generalItems.compactMap { generalItem -> GeneralList? in
                    if let generalList = generalItem as? GeneralList {
                        return generalList
                    } else {
                        return nil
                    }
                }
                
                self?.generalItemFolders = generalList
                self?.generalItemsSubject.onNext(generalList)
                
                LoadingManager.shared.setState(state: .normal(value: false))
            })
            .disposed(by: disposeBag)
    }
}
