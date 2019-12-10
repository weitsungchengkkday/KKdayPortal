//
//  GeneralImageViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class GeneralImageViewModel: RXViewModelType, PortalControllable {
 
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
    let disposeBag = DisposeBag()
    var generalItem: PortalContent?
    
    init(source: URL) {
        self.source = source
        self.input = Input(title: titleSubject.asObserver(), image: imageViewSubject.asObserver())
        
        self.output = Output(showTitle: titleSubject.asDriver(onErrorJustReturn: "Image"), showImage: imageViewSubject.asDriver(onErrorJustReturn: #imageLiteral(resourceName: "icPicture")))
    }
    
    func getPortalData() {

        ModelLoader.PortalLoader()
            .getItem(source: source, type: .image)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] generalItem in
                
                self?.generalItem = generalItem
                if let title = generalItem.title {
                    self?.titleSubject.onNext(title)
                }
                
                guard let imageURL = generalItem.imageObject?.url else {
                    return
                }
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
