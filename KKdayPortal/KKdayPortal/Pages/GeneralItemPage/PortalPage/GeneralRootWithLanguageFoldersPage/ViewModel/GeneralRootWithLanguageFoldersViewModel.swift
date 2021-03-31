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
    
    private(set) var generalItem: PortalContentList?
    private(set) var generalItemFolders: [PortalContentList] = []
    private(set) var contentListSections: [ContentListSection] = []
    
    var updateContent: () -> Void = {}
    
    var source: URL
    
    init(source: URL) {
        self.source = source
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
    
    
    private func getPortalFoldersData() {
        
        LoadingManager.shared.setState(state: .normal(value: true))
        
        let group = DispatchGroup()
        var gereralListArray: [GeneralList] = []
        
        for folder in generalItemFolders {
            if let source = folder.source {
                
                group.enter()
                ModelLoader.PortalLoader()
                    .loadItem(source: source, type: .folder) { result in
                        
                        switch result {
                        case .success(let generalItem):
                            
                            if let generalItem = generalItem as? GeneralList  {
                                gereralListArray.append(generalItem)
                            }
                            
                        case .failure(let error):
                            print("🚨 Func: \(#file),\(#function)")
                            print("Error: \(error)")
                            LoadingManager.shared.setState(state: .normal(value: false))
                            
                        }
                        group.leave()
                    }
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            let contentListSections = self.transferGeneralListsToContentListSections(generalLists: gereralListArray)
            self.contentListSections = contentListSections
            self.updateContent()
            
        }
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
        updateContent()
    }
}

