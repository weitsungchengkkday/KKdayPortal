//
//  LoadingViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/31.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

final class LoadingViewModel: ViewModelType {
    
    private let disposeBag = DisposeBag()
    
    var loadingImage: UIImage = {
        return UIImage.gifImageWithName("/Gif/cycle_loading/cycle_loading", isUseImageRetinaString: true, duration: 1500)!
    }()
    
    var state: UIState<Bool> {
        didSet {
            loadImageAndTitle()
        }
    }
    
    private let successImage: UIImage = #imageLiteral(resourceName: "icSucess")
    private let failImage: UIImage = #imageLiteral(resourceName: "icError")
    
    var input: LoadingViewModel.Input
    var output: LoadingViewModel.Output
    
    struct Input {
        let loadingImage: AnyObserver<UIImage>
        let loadingTitle: AnyObserver<(String, Bool)>
    }
    
    struct Output {
        let showLoadingImage: Driver<UIImage>
        let showLoadingTitle: Driver<(String, Bool)>
    }
    
    private let loadingImageSubject = PublishSubject<UIImage>()
    private let loadingTitleSubject = PublishSubject<(String, Bool)>()
    
    init(state: UIState<Bool>) {
        self.input = Input(loadingImage: loadingImageSubject.asObserver(), loadingTitle: loadingTitleSubject.asObserver())
        self.output = Output(showLoadingImage: loadingImageSubject.asDriver(onErrorJustReturn: #imageLiteral(resourceName: "icPicture")),
                             showLoadingTitle: loadingTitleSubject.asDriver(onErrorJustReturn: ("Loading", true)))
        self.state = state
    }
    
    func loadImageAndTitle() {
    
        switch state {
        case .normal:
            loadingImageSubject.onNext(loadingImage)
            loadingTitleSubject.onNext(("", true))
            
        case .success(value: _, message: let message, duration: _, completion: _):
            loadingImageSubject.onNext(successImage)
            loadingTitleSubject.onNext((message, false))
            
        case .error(value: _, message: let message, duration: _, completion: _):
            loadingImageSubject.onNext(failImage)
            loadingTitleSubject.onNext((message, false))
        }
    }
}
 
