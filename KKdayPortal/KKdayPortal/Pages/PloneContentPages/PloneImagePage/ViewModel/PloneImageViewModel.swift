//
//  PloneImageViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/11/30.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class PloneImageViewModel: PloneControllable, RXViewModelType {
    
    typealias PloneContent = PloneImage
    
    let apiManager: APIManager
    var route: URL
    let disposeBag = DisposeBag()
    var ploneItem: PloneContent?
    
    var input: PloneImageViewModel.Input
    var output: PloneImageViewModel.Output
    
    struct Input {
        let title: AnyObserver<String>
        let image: AnyObserver<UIImage>
    }
    
    struct Output {
        let showTitle: Driver<String>
        let showImage: Driver<UIImage>
    }
    
    private let ploneItemsSubject = PublishSubject<[PloneItem]>()
    private let titleSubject = PublishSubject<String>()
    private let imageViewSubject = PublishSubject<UIImage>()
    
    init(apiManager: APIManager, route: URL) {
        self.apiManager = apiManager
        self.route = route
        self.input = Input(title: titleSubject.asObserver(), image: imageViewSubject.asObserver())
        
        
        self.output = Output(showTitle: titleSubject.asDriver(onErrorJustReturn: "Image"), showImage: imageViewSubject.asDriver(onErrorJustReturn: #imageLiteral(resourceName: "icPicture")))
    }
    
    func getPloneData() {
        let user: PloneUser? = StorageManager.shared.loadObject(for: .ploneUser)
        let portalItem = PortalItem.Item<PloneContent>(user: user, route: route)
        let response = apiManager.request(portalItem)
        
        response
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] ploneImage in
            self?.ploneItem = ploneImage
            self?.titleSubject.onNext(ploneImage.title)
            
            let imageURL = ploneImage.image.url
            self?.dowloadImage(url: imageURL)
            
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
