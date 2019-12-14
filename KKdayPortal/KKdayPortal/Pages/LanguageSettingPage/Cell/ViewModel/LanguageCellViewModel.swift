//
//  LanguageCellViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/13.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class LanguageSettingTableViewCellViewModel {
    
    var isSelected: Bool
    let selectedLanguage: Language
 
    init(isSelected: Bool, selectedLanguage: Language) {
        self.isSelected = isSelected
        self.selectedLanguage = selectedLanguage
    }
}
