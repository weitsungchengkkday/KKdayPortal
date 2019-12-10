//
//  ItemConverter.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/7.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

struct ItemConverter {

}

// Plone -> General
extension ItemConverter {
    
    static func ploneItemToGeneralItem(item: PloneItem) -> GeneralItem {
        
        let type: GeneralItemType? = typeTransfer(ploneItem: item)
        let title: String? = item.title
        let descroption: String? = item.description
        let id: String? = item.id
        let UID: String? = item.UID
        let source: URL? = item.atID
        
        let parentType = typeTransfer(ploneItem: item.parent!)
        let parent: GeneralItem? = {
            if case .root = item.atType {
                return nil
            }
            
            guard let parent = item.parent else {
                return nil
            }
            
            let parentImageObject: GeneralImageObject? = imageObjectTypeTransfer(ploneItem: parent)
            let parentTextObject: GeneralTextObject? = textObjectTypeTransfer(ploneItem: parent)
            let parentEventObject: GeneralEventObject? = eventObjectTypeTransfer(ploneItem: parent)
            let parentFileObject: GeneralFileObject? = fileObjectTypeTransfer(ploneItem: parent)
            let parentLinkObject: GeneralLinkObject? = linkObjectTypeTransfer(ploneItem: parent)
            
            return GeneralItem(type: parentType,
                               title: parent.title,
                               description: parent.description,
                               parent: nil,
                               id: parent.id,
                               UID: parent.UID,
                               source: parent.atID,
                               imageObject: parentImageObject,
                               textObject: parentTextObject,
                               eventObject: parentEventObject,
                               fileObject: parentFileObject,
                               linkObject: parentLinkObject)
        }()
        
        let imageObject: GeneralImageObject? = imageObjectTypeTransfer(ploneItem: item)
        let textObject: GeneralTextObject? = textObjectTypeTransfer(ploneItem: item)
        let eventObject: GeneralEventObject? = eventObjectTypeTransfer(ploneItem: item)
        let fileObject: GeneralFileObject? = fileObjectTypeTransfer(ploneItem: item)
        let linkObject: GeneralLinkObject? = linkObjectTypeTransfer(ploneItem: item)
        
        let items: [GeneralItem]? = ploneItemArrayToGeneralItemArray(ploneItem: item)
        
        if let items = items {
            return GeneralList(type: type,
                               title: title,
                               description: descroption,
                               parent: parent,
                               id: id,
                               UID: UID,
                               source: source,
                               imageObject: imageObject,
                               textObject: textObject,
                               eventObject: eventObject,
                               fileObject: fileObject,
                               linkObject: linkObject,
                               items: items)
        } else {
            return GeneralItem(type: type,
                               title: title,
                               description: descroption,
                               parent: parent,
                               id: id,
                               UID: UID,
                               source: source,
                               imageObject: imageObject,
                               textObject: textObject,
                               eventObject: eventObject,
                               fileObject: fileObject,
                               linkObject: linkObject)
        }
    }
    
    private static func ploneItemArrayToGeneralItemArray(ploneItem: PloneItem) -> [GeneralItem]? {
        
        let items: [PloneItem]? = {
            switch ploneItem.atType {
            case .root:
                guard let ploneRoot = ploneItem as? PloneRoot else {
                    return nil
                }
                
                return ploneRoot.items
                
            case .folder:
                guard let ploneFolder = ploneItem as? PloneFolder else {
                    return nil
                }
                return ploneFolder.items
                
            case .collection:
                guard let ploneCollection = ploneItem as? PloneCollection else {
                    return nil
                }
                return ploneCollection.items
                
            case .document, .news, .event, .image, .file, .link:
                return nil
                
            default:
                return nil
            }
        }()
        
        guard let ploneItems = items else {
            return nil
        }
        
        return ploneItems.map({ ploneItem -> GeneralItem in
            let type = typeTransfer(ploneItem: ploneItem)
            
            return GeneralItem(type: type,
                               title: ploneItem.title,
                               description: ploneItem.description,
                               parent: nil,
                               id: nil,
                               UID: nil,
                               source: ploneItem.atID,
                               imageObject: nil,
                               textObject: nil,
                               eventObject: nil,
                               fileObject: nil,
                               linkObject: nil)
        })
    }
    
    private static func typeTransfer(ploneItem: PloneItem) -> GeneralItemType? {
        
        switch ploneItem.atType {
        case .root:
            return .root
        case .folder:
            return .folder
        case .collection:
            return .collection
        case .document:
            return .document
        case .news:
            return .news
        case .event:
            return .event
        case .image:
            return .image
        case .file:
            return .file
        case .link:
            return .link
        default:
            return nil
        }
    }
    
    
    private static func imageObjectTypeTransfer(ploneItem: PloneItem) -> GeneralImageObject? {
        
        switch ploneItem.atType {
        case .root, .folder, .collection, .document, .news, .event, .file, .link:
            return nil
        case .image:
            guard let ploneImage = ploneItem as? PloneImage else {
                return nil
            }
            return GeneralImageObject(contentType: ploneImage.image?.contentType, name: ploneImage.image?.name, url: ploneImage.image?.url)
        default:
            return nil
        }
        
    }
    
    private static func textObjectTypeTransfer(ploneItem: PloneItem) -> GeneralTextObject? {
        
        switch ploneItem.atType {
        case .root, .folder, .collection, .image, .file, .link:
            return nil
        case .document:
            guard let ploneDocument = ploneItem as? PloneDocument else {
                return nil
            }
            return GeneralTextObject(contentType: ploneDocument.text?.contentType, name: "", text: ploneDocument.text?.data)
        case .news:
            guard let ploneNews = ploneItem as? PloneNews else {
                return nil
            }
            return GeneralTextObject(contentType: ploneNews.text?.contentType, name: "", text: ploneNews.text?.data)
        case .event:
            guard let ploneEvent = ploneItem as? PloneEvent else {
                return nil
            }
            return GeneralTextObject(contentType: ploneEvent.text?.contentType, name: "", text: ploneEvent.text?.data)
        default:
            return nil
        }
    }
    
    private static func eventObjectTypeTransfer(ploneItem: PloneItem) -> GeneralEventObject? {
        
        switch ploneItem.atType {
        case .root, .folder, .collection, .document, .news, .image, .file, .link:
            return nil
        case .event:
            guard let ploneEvent = ploneItem as? PloneEvent else {
                return nil
            }
            return GeneralEventObject(contactEmail: ploneEvent.contactEmail,
                                      contactName: ploneEvent.contactName,
                                      contactPhone: ploneEvent.contactPhone,
                                      createDate: ploneEvent.createDate,
                                      startDate: ploneEvent.startDate,
                                      endDate: ploneEvent.endDate,
                                      location: ploneEvent.location,
                                      eventURL: ploneEvent.eventURL)
        default:
            return nil
        }
    }
    
    private static func fileObjectTypeTransfer(ploneItem: PloneItem) -> GeneralFileObject? {
        
        switch ploneItem.atType {
        case .root, .folder, .collection, .document, .news, .image, .event, .link:
            return nil
        case .file:
            guard let ploneFile = ploneItem as? PloneFile else {
                return nil
            }
            return GeneralFileObject(contentType: ploneFile.file.contentType, name: ploneFile.file.name, url: ploneFile.file.url)
        default:
            return nil
        }
    }
    
    private static func linkObjectTypeTransfer(ploneItem: PloneItem) -> GeneralLinkObject? {
        
        switch ploneItem.atType {
        case .root, .folder, .collection, .document, .news, .image, .file, .event:
            return nil
        case .link:
            guard let ploneLink = ploneItem as? PloneLink else {
                return nil
            }
            return GeneralLinkObject(name: ploneLink.linkTitle, url: ploneLink.remoteURL)
        default:
            return nil
        }
    }
    
}

// General -> Plone
extension ItemConverter {
    
    static func typeTransfer(generalItemType: GeneralItemType) -> PloneItemType {
        switch generalItemType {
        case .root:
            return .root
        case .folder:
            return .folder
        case .collection:
            return .collection
        case .document:
            return .document
        case .news:
            return .news
        case .event:
            return .event
        case .image:
            return .image
        case .file:
            return .file
        case .link:
            return .link
        }
    }
}
