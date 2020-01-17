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
    
    typealias PortalContentList = GeneralList
    
    var input: GeneralIndexSideBarViewModel.Input
    var output: GeneralIndexSideBarViewModel.Output
    
    struct Input {
        let generalItems: AnyObserver<[ContentListSection]>
    }
    
    struct Output {
        let showGeneralItems: Driver<[ContentListSection]>
    }
    
    private let generalItemsSubject = PublishSubject<[ContentListSection]>()
    
    private(set) var contentListSections: [ContentListSection]
    
    private let disposeBag = DisposeBag()
    
    init(contentList: [PortalContentList]) {
        
        self.contentListSections = contentList.compactMap({ generalList -> ContentListSection? in
            
            //generalList
            guard let generalItems = generalList.items else {
                return nil
            }
    
            let headerSectionItem: ContentListSectionItem = .header(cellViewModel: GeneralIndexSideBarHeaderTableViewCellViewModel(generalItem: generalList, isOpen: false))
            
            var normalSectionItems: [ContentListSectionItem] = []
            
            for generaItem in generalItems {
                normalSectionItems.append(.normal(cellViewModel: GeneralIndexSideBarNormalTableViewCellViewModel(generalItem: generaItem)))
            }
            
         return ContentListSection(header: generalList.title ?? "", items: [headerSectionItem] + normalSectionItems)
            
        })
        
        self.input = Input(generalItems: generalItemsSubject.asObserver())
        self.output = Output(showGeneralItems: generalItemsSubject.asDriver(onErrorJustReturn: []))
    }
    
    func loadPortalContent() {
        generalItemsSubject.onNext(contentListSections)
    }
    
    
    func switchSectionIsOpen(at section: Int) {
        
        if case let .header(cellViewModel: cellViewModel) = contentListSections[section].items.first {
            let isOpen: Bool = cellViewModel.isOpen
            cellViewModel.isOpen = !isOpen
        }
        
        generalItemsSubject.onNext(contentListSections)
    }
}
