//
//  LanguageViewViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/12.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class LanguageViewModel: RXViewModelType {
    
    typealias CellViewModel = LanguageSettingTableViewCellViewModel
       
    
    var input: LanguageViewModel.Input
    var output: LanguageViewModel.Output
    
    
    struct Input {
        let cellViewModels: AnyObserver<[CellViewModel]>
    }
    
    struct Output {
        let showLanguageItems: Driver<[CellViewModel]>
    }
    
    private let cellViewModelsSubject = PublishSubject<[CellViewModel]>()
    
    private let cellButtonClicked = PublishSubject<Bool>()
    
    init() {
        self.input = Input(cellViewModels: cellViewModelsSubject.asObserver())
        
        self.output = Output(showLanguageItems: cellViewModelsSubject.asDriver(onErrorJustReturn: []))
    }
    
    func nextCellViewModelsEvent() {
        cellViewModelsSubject.onNext(getCellViewModels())
    }
    
    private func getCellViewModels() -> [CellViewModel] {
        let availableLanguage: [Language] = [.en, .zhTW]
        
        let cellViewModels = availableLanguage.map { langauge -> CellViewModel in
            
            let isSelected = langauge == LanguageManager.shared.currentLanguage
            
            return CellViewModel(isSelected: isSelected, selectedLanguage: langauge)
        }
        return cellViewModels
    }
}
