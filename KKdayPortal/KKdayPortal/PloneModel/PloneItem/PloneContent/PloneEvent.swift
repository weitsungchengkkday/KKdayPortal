//
//  PloneEvent.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/28.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class PloneEvent: PloneItem {
    
    var text: PloneTextObject?

    var contactEmail: String?
    var contactName: String?
    var contactPhone: String?
    
    
    var createDate: Date?
    var startDate: Date?
    var endDate: Date?
    var location: String?
    var eventURL: URL?

    private enum CodingKeys: String, CodingKey {
        case text
        case contactEmail = "contact_email"
        case contactName = "contact_name"
        case contactPhone = "contact_phone"

        case createDate = "created"
        case startDate = "start"
        case endDate = "end"
        case location
        case eventURL = "event_url"
    }
    
    init(UID: String?, atID: URL?, atType: PloneItemType?, description: String?, title: String?, isFolderish: Bool?, parent: PloneItem?, id: String?, text: PloneTextObject?, contactEmail: String?, contactName: String?, contactPhone: String?, createDate: Date?, startDate: Date?, endDate: Date?, location: String?, eventURL: URL?) {
        
        self.text = text
        self.contactEmail = contactEmail
        self.contactName = contactName
        self.contactPhone = contactPhone
        
        self.createDate = createDate
        self.startDate = startDate
        self.endDate = endDate
        self.location = location
        self.eventURL = eventURL
        
        super.init(UID: UID, atID: atID, atType: atType, description: description, title: title, isFolderish: isFolderish, parent: parent, id: id)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try? container.decode(PloneTextObject.self, forKey: .text)
        self.contactEmail = try? container.decode(String.self, forKey: .contactEmail)
        self.contactName = try? container.decode(String.self, forKey: .contactName)
        self.contactPhone = try?
            container.decode(String.self, forKey: .contactPhone)
    
        let createDateString = try?
            container.decode(String.self, forKey: .createDate)
        self.createDate = createDateString?.removeLastColon().customDateFormatterToDate(formatter: .iso8601Full)
        let startDateString = try?
            container.decode(String.self, forKey: .startDate)
        self.startDate = startDateString?.removeLastColon().customDateFormatterToDate(formatter: .iso8601Full)
        let endDateString = try?
            container.decode(String.self, forKey: .endDate)
        self.endDate = endDateString?.removeLastColon().customDateFormatterToDate(formatter: .iso8601Full)
        
        self.location = try? container.decode(String.self, forKey: .location)
        self.eventURL = try? container.decode(URL.self, forKey: .eventURL)
        
        try super.init(from: decoder)
    }
}

