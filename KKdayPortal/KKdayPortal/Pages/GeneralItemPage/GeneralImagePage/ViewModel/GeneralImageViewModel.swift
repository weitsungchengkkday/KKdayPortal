//
//  GeneralImageViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa
import Alamofire

final class GeneralImageViewModel: ViewModelType, PortalControllable {
    
    typealias PortalContent = GeneralItem
    
    var input: GeneralImageViewModel.Input
    var output: GeneralImageViewModel.Output
    
    struct Input {
        let title: AnyObserver<String>
        let image: AnyObserver<UIImage>
    }
    
    struct Output {
        let showTitle: Driver<String>
        let showImage: Driver<UIImage>
    }
    
    private let titleSubject = PublishSubject<String>()
    private let imageViewSubject = PublishSubject<UIImage>()
    
    var source: URL
    private let disposeBag = DisposeBag()
    var generalItem: PortalContent?
    
    init(source: URL) {
        self.source = source
        self.input = Input(title: titleSubject.asObserver(), image: imageViewSubject.asObserver())
        
        self.output = Output(showTitle: titleSubject.asDriver(onErrorJustReturn: "Image"), showImage: imageViewSubject.asDriver(onErrorJustReturn: #imageLiteral(resourceName: "icPicture")))
    }
    
    func getPortalData() {
        
        LoadingManager.shared.setState(state: .normal(value: true))
        
        ModelLoader.PortalLoader()
            .getItem(source: source, type: .image)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] generalItem in
                
                LoadingManager.shared.setState(state: .normal(value: false))
                
                self?.generalItem = generalItem
                if let title = generalItem.title {
                    self?.titleSubject.onNext(title)
                }
                
                guard let imageURL = generalItem.imageObject?.url else {
                    return
                }
                self?.dowloadImage(url: imageURL)
                
            }) { error in
                
                LoadingManager.shared.setState(state: .normal(value: false))
                
                print("🚨 Func: \(#file),\(#function)")
                print("Error: \(error)")
        }
        .disposed(by: disposeBag)
    }
    
    private func dowloadImage(url: URL) {
        
        guard let user: GeneralUser = StorageManager.shared.loadObject(for: .generalUser) else {
            print("❌ No generalUser exist")
            return
        }
        
        let token = user.token
        let headers: [String : String] = [
            "Authorization" : "Bearer" + " " + token
        ]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseData { dataResponse
            in
            
            DispatchQueue.global().async { [weak self] in
                if let data = dataResponse.data {
                
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.imageViewSubject.onNext(image)
                        }
                    } else {
                        DispatchQueue.main.async {
                            let image = UIImage(systemName: "xmark.rectangle")!
                            self?.imageViewSubject.onNext(image)
                        }
                    }
                }
            }
        }
    }
    
}
