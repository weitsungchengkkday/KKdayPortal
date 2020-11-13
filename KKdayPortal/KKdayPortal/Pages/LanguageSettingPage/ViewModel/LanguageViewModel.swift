//
//  LanguageViewViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/12.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class LanguageViewModel: ViewModelType {
    
    typealias CellViewModel = LanguageSettingTableViewCellViewModel
       
    var input: LanguageViewModel.Input
    var output: LanguageViewModel.Output
    
    struct Input {
        let cellViewModels: AnyObserver<[LanguageSection]>
    }
    
    struct Output {
        let showLanguageItems: Driver<[LanguageSection]>
    }
    
    private let cellViewModelsSubject = PublishSubject<[LanguageSection]>()
    
    init() {
        self.input = Input(cellViewModels: cellViewModelsSubject.asObserver())
        
        self.output = Output(showLanguageItems: cellViewModelsSubject.asDriver(onErrorJustReturn: [LanguageSection(header: "Error", items: [])]))
    }
    
    func nextCellViewModelsEvent() {
        cellViewModelsSubject.onNext(getCellViewModels())
    }
    
    private func getCellViewModels() -> [LanguageSection] {
        let availableLanguage: [Language] = [.en, .zhTW]
        
        let cellViewModels = availableLanguage.map { langauge -> CellViewModel in
            
            let isSelected = langauge == LanguageManager.shared.currentLanguage
            
            return CellViewModel(isSelected: isSelected, selectedLanguage: langauge)
        }
        return [LanguageSection(header: "Language", items: cellViewModels)]
    }
}
