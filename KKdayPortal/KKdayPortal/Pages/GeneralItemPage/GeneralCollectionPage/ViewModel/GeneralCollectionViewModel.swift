//
//  GeneralCollectionViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/9.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa
import SwiftSoup
import HTMLString

final class GeneralCollectionViewModel: RXViewModelType, PortalControllable {
    
    typealias PortalContent = GeneralItem
    
    var input: GeneralCollectionViewModel.Input
    var output: GeneralCollectionViewModel.Output
    
    struct Input {
        let generalItems: AnyObserver<[PortalContent]>
        let collectionContentItems: AnyObserver<[GeneralTextObjectSection]>
        let title: AnyObserver<String>
    }
    
    struct Output {
        let showGeneralItems: Driver<[PortalContent]>
        let showCollectionContentItems: Driver<[GeneralTextObjectSection]>
        let showTitle: Driver<String>
    }
    
    private let generalItemsSubject = PublishSubject<[PortalContent]>()
    private let collectionContentItemsSubject = PublishSubject<[GeneralTextObjectSection]>()
    private let titleSubject = PublishSubject<String>()
    
    var generalItem: PortalContent?
    var source: URL
    private let disposeBag = DisposeBag()
    
    init(source: URL) {
        self.source = source
        
        self.input = Input(generalItems: generalItemsSubject.asObserver(),
                           collectionContentItems: collectionContentItemsSubject.asObserver(),
                           title: titleSubject.asObserver()
        )
        
        self.output = Output(showGeneralItems: generalItemsSubject.asDriver(onErrorJustReturn: []),
                             showCollectionContentItems: collectionContentItemsSubject.asDriver(onErrorJustReturn: []),
                             showTitle: titleSubject.asDriver(onErrorJustReturn: "Collection")
        )
    }
    
    func getPortalData() {
        
        LoadingManager.shared.setState(state: .normal(value: true))
        
        ModelLoader.PortalLoader().getItem(source: source, type: .collection)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] generalItem in
                
                LoadingManager.shared.setState(state: .normal(value: false))
                
                guard let generalItem = generalItem as? GeneralList else {
                    return
                }
                
                self?.generalItem = generalItem
                if let items = generalItem.items {
                    self?.generalItemsSubject.onNext(items)
                }
                
                // Load to content TableView
                if let textOnbject = self?.generalItem?.textObject {
                    
                    if let textObjectText = textOnbject.text {
                        
                        var collectionContentSections: [GeneralTextObjectSection] = []
                        
                        guard let normalTextObjectText = textObjectText.switchSelfClosingTagToNormalClosingTag() else {
                            print("❌ switch self-closing-tag to normal-closing-tag fail")
                            self?.collectionContentItemsSubject.onNext([])
                            
                            return
                        }
                        
                        let htmlString = normalTextObjectText.removingHTMLEntities
                        
                        let sectionItems =  self?.createCollectionContentSectionItems(htmlText: htmlString)
                        
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
                        
                        collectionContentSections.append(GeneralTextObjectSection(header: "", items: (normalSectionItem + iframeSectionItem + imageSectionItem)))
                        self?.collectionContentItemsSubject.onNext(collectionContentSections)
                    }
                }
                
                if let title = generalItem.title {
                    self?.titleSubject.onNext(title)
                }
                
            }) { error in
                
                LoadingManager.shared.setState(state: .normal(value: false))
                
                print("🚨 Func: \(#file),\(#function)")
                print("Error: \(error)")
        }
        .disposed(by: disposeBag)
    }
    
    private func createCollectionContentSectionItems(htmlText: String) -> [ GeneralTextObjectSectionItem]? {
        
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
            
            // Handle inner tag, <p><img alt="..." src="..." class="..."></p>
            do {
                let imageArray = try doc.select("img").array()
                
                for (index, element) in imageArray.enumerated() {
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
