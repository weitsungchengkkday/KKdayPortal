//
//  GeneralTextObjectConverter.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/4.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import SwiftSoup

struct GeneralTextObjectConverter {
    
}

extension GeneralTextObjectConverter {
    
    static func generalTextObjectToGeneralTextObjectSectionArray(textObject: GeneralTextObject) -> [GeneralTextObjectSection] {
        
        guard let textObjectText = textObject.text else {
            return []
        }
        var generalTextObjectSections: [GeneralTextObjectSection] = []
        
        guard let normalClosingTagTextObjectText = textObjectText.switchSelfClosingTagToNormalClosingTag() else {
            print("❌ switch self-closing-tag to normal-closing-tag fail")
            return []
        }
        let htmlString = normalClosingTagTextObjectText.removingHTMLEntities
        let sectionItems =  configureGeneralTextObjectSectionItems(htmlText: htmlString)
        
        var normalSectionItem: [GeneralTextObjectSectionItem] = []
        var iframeSectionItem: [GeneralTextObjectSectionItem] = []
        var imageSectionItem: [GeneralTextObjectSectionItem] = []
        
        sectionItems?.forEach({ sectionItem in
            
            switch sectionItem {
            case .normal(cellViewModel: let cellViewModel):
                normalSectionItem.append(GeneralTextObjectSectionItem.normal(cellViewModel: cellViewModel))
            case .iframe(cellViewModel: let cellViewModel):
                iframeSectionItem.append(GeneralTextObjectSectionItem.iframe(cellViewModel: cellViewModel))
            case .image(cellViewModel: let cellViewModel):
                imageSectionItem.append(GeneralTextObjectSectionItem.image(cellViewModel: cellViewModel))
            }
        })
        
        generalTextObjectSections.append(GeneralTextObjectSection(header: "", items: (normalSectionItem + iframeSectionItem + imageSectionItem)))
        
        return generalTextObjectSections
    }
    
    private static func configureGeneralTextObjectSectionItems(htmlText: String) -> [GeneralTextObjectSectionItem]? {
        
        guard let normalHTMLText = htmlText.switchSelfClosingTagToNormalClosingTag() else {
            return nil
        }
        
        var sectionItems: [GeneralTextObjectSectionItem] = []
        
        do {
            let doc: Document = try SwiftSoup.parseBodyFragment(normalHTMLText)
            
            // Handle double layers tag, <p><iframe>...</iframe></p>
            do {
                let iframeArray = try doc.select("iframe").array()
                
                for (index , element) in iframeArray.enumerated() {
                    do {
                        let urlString = try element.attr("src")
                        
                        if let url = URL(string: urlString) {
                            sectionItems.append( GeneralTextObjectSectionItem.iframe(cellViewModel: GeneralTextObjectIFrameTableViewCellViewModel(title: "(表\(index + 1))", url: url)))
                        } else {
                            print("❌ not valid urlString")
                        }
                        
                        let textNode = TextNode("(查看 表\(index + 1))", nil)
                        
                        do {
                            try element.replaceWith(textNode)
                            
                        } catch {
                            print("❌ SwiftSoup,iframe element can't be replaced")
                        }
                        
                    } catch {
                        print("❌ SwiftSoup, No src in iframe tag, Error: \(error)")
                    }
                }
                
            } catch {
                print("⚠️ No iframe exist, Error: \(error)")
            }
            
            // Handle double layers tag(img is inner tag), <p><img alt="..." src="..." class="..."></p>
            
            do {
                let imageArray = try doc.select("img").array()
                
                // remove sigle layer, <img alt="..." src="..." class="...">
                let array = imageArray.filter { element -> Bool in
                    return element.parent()?.tagName() != "div"
                }
                
                for (index, element) in array.enumerated() {
                    
                    do {
                        let urlString = try element.attr("src")
                        
                        if let url = URL(string: urlString) {
                            sectionItems.append(GeneralTextObjectSectionItem.image(cellViewModel: GeneralTextObjectImageTableViewCellViewModel(title: "(圖\(index + 1))", url: url)))
                        } else {
                            print("❌ not valid urlString")
                        }
                        
                        let textNode = TextNode("(查看 圖\(index + 1))", nil)
                        
                        do {
                            try element.replaceWith(textNode)
                        } catch {
                            print("❌ SwiftSoup, img element can't be replaced")
                        }
                        
                    } catch {
                        print("❌ SwiftSoup, No src in img tag, Error: \(error)")
                    }
                }
                
            } catch {
                print("⚠️ No img exist, Error: \(error)")
            }
            
            do {
                let htmlString = try doc.html()
                sectionItems.insert( GeneralTextObjectSectionItem.normal(cellViewModel: GeneralTextObjectNormalTableViewCellViewModel(title: "", text: htmlString)), at: 0)
            } catch {
                print("❌")
            }
            
        } catch {
            print("⚠️ No img exist, Error: \(error)")
        }
        
        return sectionItems
    }
}
