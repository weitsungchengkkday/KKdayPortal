//
//  GeneralRootWithLanguageFoldersViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/14.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class GeneralRootWithLanguageFoldersViewModel {
    
    typealias PortalContent = GeneralItem
    typealias PortalContentList = GeneralList
    
//    var input: GeneralRootWithLanguageFoldersViewModel.Input
//    var output: GeneralRootWithLanguageFoldersViewModel.Output
//
//    struct Input {
//        let generalItems: AnyObserver<[ContentListSection]>
    //    }
    //
    //    struct Output {
    //        let showGeneralItems: Driver<[ContentListSection]>
    //    }
    //
    //    private let generalItemsSubject = PublishSubject<[ContentListSection]>()
    
    private(set) var generalItem: PortalContentList?
    private(set) var generalItemFolders: [PortalContentList] = []
    private(set) var contentListSections: [ContentListSection] = []
    
    var source: URL
    
    init(source: URL) {
        self.source = source
        //
        //        self.input = Input(generalItems: generalItemsSubject.asObserver())
        //        self.output = Output(showGeneralItems: generalItemsSubject.asDriver(onErrorJustReturn: []))
    }
    
    func loadPortalData() {
        LoadingManager.shared.setState(state: .normal(value: true))
        
        ModelLoader.PortalLoader()
            .loadItem(source: source, type: .event) { [weak self] result in
                
                switch result {
                case .success(let generalItem):
                    LoadingManager.shared.setState(state: .normal(value: true))
                    
                    guard let generalItem = generalItem as? GeneralList else {
                        return
                    }
                    
                    self?.generalItem = generalItem
                    if let items = generalItem.items {
                        
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
                    
                    self?.getPortalFoldersData()
                    
                case .failure(let error):
                    print("🚨 Func: \(#file),\(#function)")
                    print("Error: \(error)")
                    
                    LoadingManager.shared.setState(state: .normal(value: false))
                }
            }
    }
    
          
    private func getSSSData() {
        
        LoadingManager.shared.setState(state: .normal(value: true))
       
        for folder in generalItemFolders {
            if let source = folder.source {
                
                ModelLoader.PortalLoader()
                    .loadItem(source: source, type: .folder) { [weak self] result in
                    
                    
                }
                
            }
            
        }
        
        
    }
        
        
    
    
    private func getPortalFoldersData() {
        
        var generalItemObservables: [Observable<GeneralItem>] = []
        
        for folder in generalItemFolders {
            if let source = folder.source {
                let generalItemObservable = ModelLoader.PortalLoader()
                    .getItem(source: source, type: .folder).asObservable()
                generalItemObservables.append(generalItemObservable)
            }
        }
        
        LoadingManager.shared.setState(state: .normal(value: true))
        
        
        
        
        
        Observable.combineLatest(generalItemObservables)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] generalItems in
                
                let generalLists =  generalItems.compactMap { generalItem -> GeneralList? in
                    if let generalList = generalItem as? GeneralList {
                        return generalList
                    } else {
                        return nil
                    }
                }
                
                self?.generalItemFolders = generalLists
                
                if let contentListSections = self?.transferGeneralListsToContentListSections(generalLists: generalLists) {
                    
                    self?.contentListSections = contentListSections
                    self?.generalItemsSubject.onNext(contentListSections)
                }
    
                LoadingManager.shared.setState(state: .normal(value: false))
            })
            .disposed(by: disposeBag)
    }
    
    
    private func transferGeneralListsToContentListSections(generalLists: [GeneralList]) -> [ContentListSection] {
        
        guard generalLists.count > 0 else {
            return []
        }
        var sections: [ContentListSection] = []
        
        for generalList in generalLists {
            
            var sectionItems: [ContentListSectionItem] = []
            
             sectionItems.append(.header(cellViewModel: GeneralRootWithLanguageFoldersHeaderTableViewCellViewModel(generalItem: generalList, isOpen: false)))
            
            if let items = generalList.items, items.count != 0 {
                for item in items {
                sectionItems.append(.normal(cellViewModel: GeneralRootWithLanguageFoldersNormalTableViewCellViewModel(generalItem: item)))
                }
            }
            
            sections.append(ContentListSection(header: "", items: sectionItems))
        }
        
        return sections
    }
    
    func switchSectionIsOpen(at section: Int) {

         if case let .header(cellViewModel: cellViewModel) = contentListSections[section].items.first {
             let isOpen: Bool = cellViewModel.isOpen
             cellViewModel.isOpen = !isOpen
         }

         generalItemsSubject.onNext(contentListSections)
     }
}

