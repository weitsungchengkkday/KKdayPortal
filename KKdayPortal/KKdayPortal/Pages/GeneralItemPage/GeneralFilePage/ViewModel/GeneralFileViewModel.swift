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
    }
    
    struct Output {
        let showTitle: Driver<String>
    }
    
    private let titleSubject = PublishSubject<String>()
    
    var source: URL
    private let disposeBag = DisposeBag()
    var generalItem: PortalContent?
    
        init(source: URL) {
           
            self.source = source
            
            self.input = Input(title: titleSubject.asObserver())
            
            self.output = Output(showTitle: titleSubject.asDriver(onErrorJustReturn: "File")
            )
        }
        
        func getPortalData() {
            
            ModelLoader.PortalLoader()
                .getItem(source: source, type: .file)
                .subscribeOn(MainScheduler.instance)
                .subscribe(onSuccess: { [weak self] generalItem in
                    
                    self?.generalItem = generalItem
                    if let title = generalItem.title {
                        self?.titleSubject.onNext(title)
                    }
                    
                }) { error in
                    print("🚨 Func: \(#file),\(#function)")
                    print("Error: \(error)")
            }
            .disposed(by: disposeBag)
        }
        
        func downloadFile(fileURL: URL) {
            let user: PloneUser? = StorageManager.shared.loadObject(for: .generalUser)
            
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


