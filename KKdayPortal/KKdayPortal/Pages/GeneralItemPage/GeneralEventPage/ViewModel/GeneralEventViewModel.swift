//
//  GeneralEventViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//
import Foundation

final class GeneralEventViewModel {
    
    typealias PortalContent = GeneralItem
    
    var generalItem: PortalContent?
    
    private(set) var eventTitle: String = ""
    private(set) var eventDescription: String = ""
    private(set) var eventContact: String = ""
    private(set) var eventEvent: String = ""
    private(set) var eventGeneralTextObjectItems: [GeneralTextObjectSection] = []
    
    var updateContent: () -> Void = {}
    
    var source: URL
    
    init(source: URL) {
        self.source = source
    }
    
    func loadPortalData() {
        LoadingManager.shared.setState(state: .normal(value: true))
        
        ModelLoader.PortalLoader()
            .loadItem(source: source, type: .event) { [weak self] result in
                
                switch result {
                case .success(let generalItem):
                    LoadingManager.shared.setState(state: .normal(value: false))
                    self?.generalItem = generalItem
                    
                    if let title = generalItem.title {
                        self?.eventTitle = title
                    }
                    
                    if let description = generalItem.description {
                        self?.eventDescription = description
                    }
                    
                    let contactInfo = """
                                contactName: \(generalItem.eventObject?.contactName ?? "No Info")
                                contactEmail: \(generalItem.eventObject?.contactEmail ?? "No Info")
                                contactPhone: \(generalItem.eventObject?.contactPhone ?? "No Info")
                                """
                    self?.eventContact = contactInfo
                    
                    let eventInfo = """
                                createDate: \(generalItem.eventObject?.createDate?.description ?? "No Info")
                                startDate: \(generalItem.eventObject?.startDate?.description ?? "No Info")
                                endDate: \(generalItem.eventObject?.endDate?.description ?? "No Info")
                                location: \(generalItem.eventObject?.location ?? "No Info")
                                eventURL: \(generalItem.eventObject?.eventURL?.absoluteString ?? "No Info")
                                """
                    
                    self?.eventEvent = eventInfo
                    
                    if let textObject = generalItem.textObject {
                        let generalTextObjectSections = GeneralTextObjectConverter.generalTextObjectToGeneralTextObjectSectionArray(textObject: textObject)
                        
                        self?.eventGeneralTextObjectItems = generalTextObjectSections
                    }
                    
                case .failure(let error):
                    print("🚨 Func: \(#file),\(#function)")
                    print("Error: \(error)")
                    LoadingManager.shared.setState(state: .normal(value: false))
                }
                
                self?.updateContent()
            }
    }
    
}



