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
    
    private(set) var linkObjects: [ApplicationLinkObject] = []
    private(set) var isLoading: Bool = false
    
    private var defaultLinkObjects: [ApplicationLinkObject] = {
        let urls = [
            ApplicationLinkObject(name: "BPM", description: "簽核系統", url: URL(string: ConfigManager.shared.model.host + "/Plone/zh-tw/02-all-services/bpm")!)
        ]
               
        return urls
    }()
    
    var updateContent: () -> Void = {}
    
    init() { }
    
    func loadPortalData() {
        self.linkObjects += defaultLinkObjects
        updateContent()
    }
    
}

struct ApplicationLinkObject {
    
    let name: String
    let description: String
    let url: URL
}

