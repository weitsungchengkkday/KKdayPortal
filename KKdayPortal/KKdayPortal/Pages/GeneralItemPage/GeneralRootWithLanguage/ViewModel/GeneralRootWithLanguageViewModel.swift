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
        let generalItemsOfFolders: AnyObserver<[PortalContentList]>
        let generalItemsOfDocument: AnyObserver<PortalContent>
    }
    
    struct Output {
        let showGeneralItemsOfFolders: Driver<[PortalContentList]>
        let showGeneralItemsOfDocument: Driver<PortalContent>
    }
    
    private let generalItemsOfFoldersSubject = PublishSubject<[PortalContentList]>()
    private let generalItemsOfDocumentSubject = PublishSubject<PortalContent>()
    private let titleSubject = PublishSubject<String>()
    
    var generalItem: PortalContentList?
    
    var generalItemDocument: PortalContent?
    
    var generalItemFolders: [PortalContentList] = []
    
    var source: URL
    private let disposeBag = DisposeBag()
    
    init(source: URL) {
        self.source = source
        
        self.input = Input(generalItemsOfFolders: generalItemsOfFoldersSubject.asObserver(), generalItemsOfDocument: generalItemsOfDocumentSubject.asObserver()
        )
        
        self.output = Output(showGeneralItemsOfFolders: generalItemsOfFoldersSubject.asDriver(onErrorJustReturn: []), showGeneralItemsOfDocument: generalItemsOfDocumentSubject.asDriver(onErrorJustReturn:
            PortalContent(type: .document,
                          title: "Home",
                          description: "Welcome To KKday Website",
                          parent: nil,
                          id: nil,
                          UID: nil,
                          source: nil)))
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
                
                if self?.generalItemDocument?.source == generalItem.source {
                    self?.generalItemDocument = generalItem
                    self?.generalItemsOfDocumentSubject.onNext(generalItem)
                    print("🌝")
                } else {
                    print("🌙")
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
                        print("🍎")
                        return generalList
                    } else {
                        print("🍏")
                        return nil
                    }
                }
                
                print(generalList)
                self?.generalItemsOfFoldersSubject.onNext(generalList)
                LoadingManager.shared.setState(state: .normal(value: false))
                
            })
            .disposed(by: disposeBag)
    }
}
