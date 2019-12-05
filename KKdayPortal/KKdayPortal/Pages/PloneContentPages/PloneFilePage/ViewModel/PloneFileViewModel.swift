//
//  PloneFileViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/30.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class PloneFileViewModel: PloneControllable, RXViewModelType {
    
    typealias PloneContent = PloneFile
    
    let apiManager: APIManager
    var route: URL
    let disposeBag = DisposeBag()
    var ploneItem: PloneContent?
    
    var input: PloneFileViewModel.Input
    var output: PloneFileViewModel.Output
       
    struct Input {
        let title: AnyObserver<String>
    }
    
    struct Output {
        let showTitle: Driver<String>
    }
    
    private let ploneItemsSubject = PublishSubject<[PloneItem]>()
    private let titleSubject = PublishSubject<String>()
    
    init(apiManager: APIManager, route: URL) {
        self.apiManager = apiManager
        self.route = route
        
        self.input = Input(title: titleSubject.asObserver())
        
        self.output = Output(showTitle: titleSubject.asDriver(onErrorJustReturn: "File")
        )
    }
    
    func getPloneData() {
        let user: PloneUser? = StorageManager.shared.loadObject(for: .ploneUser)
        let portalItem = PortalItem.Item<PloneContent>(user: user, route: route)
        let response = apiManager.request(portalItem)
    
        response
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] ploneFile in
                
                self?.ploneItem = ploneFile
                if let title = ploneFile.title {
                    self?.titleSubject.onNext(title)
                }
                
            }) { error in
                print("🚨 Func: \(#file),\(#function)")
                print("Error: \(error)")
        }
        .disposed(by: disposeBag)
    }
    
    func downloadFile(fileURL: URL) {
        let user: PloneUser? = StorageManager.shared.loadObject(for: .ploneUser)
        
        let unclassifiedFile = PortalFile.Unclassified(user: user, fileRoute: fileURL)
        FileManager.default.downloadFile(unclassifiedFile)
            .subscribe(onSuccess: { data in
                print(type(of: data))
                
            }) { error in
                print(error)
        }
        .disposed(by: disposeBag)
    }
   
    
}


