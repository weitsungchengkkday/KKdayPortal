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
    
    var input: GeneralRootWithLanguageViewModel.Input
    var output: GeneralRootWithLanguageViewModel.Output
    
    struct Input {
        let generalItemsOfFolders: AnyObserver<[PortalContent]>
        let generalItemsOfDocument: AnyObserver<PortalContent>
    }
    
    struct Output {
        let showGeneralItemsOfFolders: Driver<[PortalContent]>
        let showGeneralItemsOfDocument: Driver<PortalContent>
        
    }
    
    private let generalItemsOfFoldersSubject = PublishSubject<[PortalContent]>()
    private let generalItemsOfDocumentSubject = PublishSubject<PortalContent>()
    
    private let titleSubject = PublishSubject<String>()
    
    var generalItem: PortalContent?
    
    var generalItemDocument: PortalContent? {
        didSet {
            if let generalItemDocunment = generalItemDocument {
                generalItemsOfDocumentSubject.onNext(generalItemDocunment)
            }
        }
    }
    
    var generalItemFolders: [PortalContent] = [] {
        didSet {
            generalItemsOfFoldersSubject.onNext(generalItemFolders)
        }
    }
    
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
                    let documentItem = items.filter ({ $0.type == .document })
                    self?.generalItemDocument = documentItem.first
                    
                    let foldersItems = items.filter({ $0.type == .folder })
                    self?.generalItemFolders  = foldersItems
                }
                
                self?.getPortalSecondLevelData()
                
            }) { error in
                print("🚨 Func: \(#file),\(#function)")
                print("Error: \(error)")
                
                LoadingManager.shared.setState(state: .normal(value: false))
        }
        .disposed(by: disposeBag)
    }
    
    
    private func getPortalSecondLevelData() {
        if let source = generalItemDocument?.source {
            self.getPortalDocumentData(source: source)
        }
        
        for folder in generalItemFolders {
            if let source = folder.source {
                self.getPortalFolderData(source: source)
            }
        }
    }
    
    private func getPortalDocumentData(source: URL) {
        
        LoadingManager.shared.setState(state: .normal(value: true))
        
        ModelLoader.PortalLoader().getItem(source: source, type: .document)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] generalItem in
                
                LoadingManager.shared.setState(state: .normal(value: false))
                
                if self?.generalItemDocument?.source == generalItem.source {
                    self?.generalItemDocument = generalItem
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
    
    private func getPortalFolderData(source: URL) {
        
        LoadingManager.shared.setState(state: .normal(value: true))
        
        ModelLoader.PortalLoader().getItem(source: source, type: .folder)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] generalItem in
                
                guard let strongSelf = self else { return }
                
                LoadingManager.shared.setState(state: .normal(value: false))
                let generalItemFolders = strongSelf.generalItemFolders
                
                for (index, folder) in generalItemFolders.enumerated() {
                    
                    if folder.source == generalItem.source {
                        self?.generalItemFolders[index] = generalItem
                        print("🍎")
                    } else {
                        print("🍏")
                    }
                }
                
            }) { error in
                print("🚨 Func: \(#file),\(#function)")
                print("Error: \(error)")
                
                LoadingManager.shared.setState(state: .normal(value: false))
        }
        .disposed(by: disposeBag)
    }
    
}
