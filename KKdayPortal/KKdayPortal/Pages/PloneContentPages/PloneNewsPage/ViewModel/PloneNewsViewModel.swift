//
//  PloneNewsViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/30.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class PloneNewsViewModel: PloneControllable, RXViewModelType {
    
    typealias PloneContent = PloneNews
    
    let apiManager: APIManager
    var route: URL
    let disposeBag = DisposeBag()
    var ploneItem: PloneContent?
    
    var input: PloneNewsViewModel.Input
    var output: PloneNewsViewModel.Output
       
    struct Input {
        let title: AnyObserver<String>
        let image: AnyObserver<UIImage>
        let dataText: AnyObserver<String>
    }
    
    struct Output {
        let showTitle: Driver<String>
        let showImage: Driver<UIImage>
        let showDataText: Driver<String>
    }
    
    private let ploneItemsSubject = PublishSubject<[PloneItem]>()
    private let titleSubject = PublishSubject<String>()
    private let imageViewSubject = PublishSubject<UIImage>()
    private let dataTextSubject = PublishSubject<String>()
    
    init(apiManager: APIManager, route: URL) {
        self.apiManager = apiManager
        self.route = route
        
        self.input = Input(title: titleSubject.asObserver(),
                           image: imageViewSubject.asObserver(),
                           dataText: dataTextSubject.asObserver())
        
        self.output = Output(showTitle: titleSubject.asDriver(onErrorJustReturn: "News"),
                             showImage: imageViewSubject.asDriver(onErrorJustReturn: #imageLiteral(resourceName: "icPicture")),
                             showDataText: dataTextSubject.asDriver(onErrorJustReturn: ""))
    }
    
    func getPloneData() {
        let user: PloneUser? = StorageManager.shared.loadObject(for: .ploneUser)
        let portalItem = PortalItem.Item<PloneContent>(user: user, route: route)
        let response = apiManager.request(portalItem)
    
        response
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] ploneNews in
            
            self?.ploneItem = ploneNews
            self?.titleSubject.onNext(ploneNews.title)
                
                let imageURL = ploneNews.image.url
                self?.dowloadImage(url: imageURL)
                self?.dataTextSubject.onNext(ploneNews.text.data)
       
        }) { error in
              print("🚨 Func: \(#file),\(#function)")
              print("Error: \(error)")
        }
        .disposed(by: disposeBag)
    }
    
    private func dowloadImage(url: URL) {
          DispatchQueue.global().async { [weak self] in
              if let data = try? Data(contentsOf: url) {
                  if let image = UIImage(data: data) {
                      DispatchQueue.main.async {
                          self?.imageViewSubject.onNext(image)
                      }
                  }
              }
          }
      }
    
}
