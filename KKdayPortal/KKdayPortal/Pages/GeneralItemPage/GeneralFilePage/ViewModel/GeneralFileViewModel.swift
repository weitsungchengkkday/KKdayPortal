//
//  GeneralFileViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class GeneralFileViewModel: RXViewModelType, PortalControllable {
    
    typealias PortalContent = GeneralItem
    
    var input: GeneralFileViewModel.Input
    var output: GeneralFileViewModel.Output
    
    struct Input {
        let title: AnyObserver<String>
        let generalFileObject: AnyObserver<GeneralFileObject?>
    }
    
    struct Output {
        let showTitle: Driver<String>
        let showGeneralFileObject: Driver<GeneralFileObject?>
    }
    
    private let titleSubject = PublishSubject<String>()
    private let generalFileObject = PublishSubject<GeneralFileObject?>()
    
    var source: URL
    private let disposeBag = DisposeBag()
    var generalItem: PortalContent?
    
    init(source: URL) {
       
        self.source = source
        
        self.input = Input(title: titleSubject.asObserver(), generalFileObject: generalFileObject.asObserver())
        
        self.output = Output(showTitle: titleSubject.asDriver(onErrorJustReturn: "File"), showGeneralFileObject: generalFileObject.asDriver(onErrorJustReturn: nil))
    }
    
    func getPortalData() {
        
        LoadingManager.shared.setState(state: .normal(value: true))
        
        ModelLoader.PortalLoader()
            .getItem(source: source, type: .file)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] generalItem in
                LoadingManager.shared.setState(state: .normal(value: false))
                
                self?.generalItem = generalItem
                if let title = generalItem.title {
                    self?.titleSubject.onNext(title)
                }
             
                if let fileObject = generalItem.fileObject {
                    self?.generalFileObject.onNext(fileObject)
                }
                
            }) { error in
                LoadingManager.shared.setState(state: .normal(value: false))
                
                print("🚨 Func: \(#file),\(#function)")
                print("Error: \(error)")
        }
        .disposed(by: disposeBag)
    }
    
}


