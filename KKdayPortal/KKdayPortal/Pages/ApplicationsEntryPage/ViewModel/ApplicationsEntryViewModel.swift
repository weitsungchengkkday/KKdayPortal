//
//  ApplicationsEntryViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/18.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class ApplicationsEntryViewModel: RXViewModelType, PortalControllable {
    
       typealias PortalContent = GeneralItem
    
       var input: ApplicationsEntryViewModel.Input
       var output: ApplicationsEntryViewModel.Output
       
       struct Input {
           let generalItems: AnyObserver<[PortalContent]>
       }
       
       struct Output {
           let showGeneralItems: Driver<[PortalContent]>
       }
       
       private let generalItemsSubject = PublishSubject<[PortalContent]>()
          private let titleSubject = PublishSubject<String>()
       
       var generalItem: PortalContent?
       var source: URL
       let disposeBag = DisposeBag()
       
       init(source: URL) {
           self.source = source
             
             self.input = Input(generalItems: generalItemsSubject.asObserver())
             
             self.output = Output(showGeneralItems: generalItemsSubject.asDriver(onErrorJustReturn: []))
         }
      
       func getPortalData() {
           
           ModelLoader.PortalLoader().getItem(source: source, type: .folder)
               .subscribeOn(MainScheduler.instance)
               .subscribe(onSuccess: { [weak self] generalItem in
                   
                   guard let generalItem = generalItem as? GeneralList else {
                       return
                   }
                   
                   self?.generalItem = generalItem
                   if let items = generalItem.items {
                       self?.generalItemsSubject.onNext(items)
                   }
                   if let title = generalItem.title {
                       self?.titleSubject.onNext(title)
                   }
                   
               }) { error in
                   print("🚨 Func: \(#file),\(#function)")
                   print("Error: \(error)")
           }
           .disposed(by: disposeBag)
       }
       
}
