//
//  LanguageCellViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/13.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

final class LanguageSettingTableViewCellViewModel {
    
    var isSelected: Bool
    let selectedLanguage: Language
 
    init(isSelected: Bool, selectedLanguage: Language) {
        self.isSelected = isSelected
        self.selectedLanguage = selectedLanguage
    }
}

extension LanguageSettingTableViewCellViewModel: IdentifiableType, Equatable {
    
    typealias Identity = String
    
    var identity: String {
        return selectedLanguage.identity
    }
    
    static func == (lhs: LanguageSettingTableViewCellViewModel, rhs: LanguageSettingTableViewCellViewModel) -> Bool {
        
        return lhs.identity == rhs.identity
    }
}
