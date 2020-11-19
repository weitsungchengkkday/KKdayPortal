//
//  ApplicationsEntryViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/18.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class ApplicationsEntryViewModel {
    
    typealias PortalContent = GeneralItem
    
    private(set) var generalItemURL: [URL] = []
    private(set) var isLoading: Bool = false
    
//    var input: ApplicationsEntryViewModel.Input
//    var output: ApplicationsEntryViewModel.Output
//
//    struct Input {
//        let generalItemsURL: AnyObserver<[URL]>
//        let isLoading: AnyObserver<Bool>
//    }
//
//    struct Output {
//        let showGeneralItemsURL: Driver<[URL]>
//        let showIsLoading: Driver<Bool>
//    }
    
//    private let generalItemsURLSubject = PublishSubject<[URL]>()
//    private let isLoadingSubject = PublishSubject<Bool>()
//
    var generalItemsURL: [URL] = {
        let urls = [ URL(string: ConfigManager.shared.model.host + "/Plone/zh-tw/02-all-services/bpm")!]
      
        return urls
    }()
    

    
    init() { }
    
    func loadPortalData() {
        generalItemsURLSubject.onNext(generalItemsURL)
    }
    
}
