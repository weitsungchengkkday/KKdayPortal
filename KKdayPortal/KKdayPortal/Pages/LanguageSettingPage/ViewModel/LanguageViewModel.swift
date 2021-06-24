//
//  LanguageViewViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/12.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

final class LanguageViewModel {
    
    typealias CellViewModel = LanguageSettingTableViewCellViewModel
   
    private(set) var languageItems: [LanguageSection] = []
 
    init() {}
    
    func loadLanguageItems() {
        
        let availableLanguage: [Language] = [.en, .zhTW, .zhCN, .ja]
        let cellViewModels = availableLanguage.map { langauge -> CellViewModel in
            
            let isSelected = langauge == LanguageManager.shared.currentLanguage
            
            return CellViewModel(isSelected: isSelected, selectedLanguage: langauge)
        }
      
        languageItems = [LanguageSection(header: "Language", items: cellViewModels)]
    }
}
