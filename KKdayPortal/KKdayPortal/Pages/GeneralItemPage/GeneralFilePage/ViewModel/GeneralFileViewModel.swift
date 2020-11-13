//
//  GeneralFileViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/8.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa
import Alamofire

final class GeneralFileViewModel: ViewModelType, PortalControllable {
    
    typealias PortalContent = GeneralItem
    
    var input: GeneralFileViewModel.Input
    var output: GeneralFileViewModel.Output
    
    struct Input {
        let title: AnyObserver<String>
        let generalFileObject: AnyObserver<GeneralFileObject?>
        let fileLocalURL: AnyObserver<URL?>
    }
    
    struct Output {
        let showTitle: Driver<String>
        let showGeneralFileObject: Driver<GeneralFileObject?>
        let showLocalURL: Driver<URL?>
    }
    
    private let titleSubject = PublishSubject<String>()
    private let generalFileObjectSubject = PublishSubject<GeneralFileObject?>()
    private let localURLSubject = PublishSubject<URL?>()
    
    var source: URL
    private let disposeBag = DisposeBag()
    var generalItem: PortalContent?
    private var generalFileObject: GeneralFileObject?
    
    init(source: URL) {
        self.source = source
        self.input = Input(title: titleSubject.asObserver(),
                           generalFileObject: generalFileObjectSubject.asObserver(),
                           fileLocalURL: localURLSubject.asObserver())
        
        self.output = Output(showTitle: titleSubject.asDriver(onErrorJustReturn: "File"),
                             showGeneralFileObject: generalFileObjectSubject.asDriver(onErrorJustReturn: nil),
                             showLocalURL: localURLSubject.asDriver(onErrorJustReturn: nil))
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
                
                self?.generalFileObject = generalItem.fileObject
                if let fileObject = generalItem.fileObject {
                    self?.generalFileObjectSubject.onNext(fileObject)
                }
                
            }) { error in
                LoadingManager.shared.setState(state: .normal(value: false))
                print("🚨 Func: \(#file),\(#function)")
                print("Error: \(error)")
        }
        .disposed(by: disposeBag)
    }
    
    func storeAndShare() {
        
        guard let user: GeneralUser = StorageManager.shared.loadObject(for: .generalUser) else {
            print("❌ No generalUser exist")
            return
        }
        
        let token = user.token
        let headers: [String : String] = [
            "Authorization" : "Bearer" + " " + token
        ]
        
        guard let fileName = generalItem?.id else {
            print("❌ No generalItem exist")
            return
        }
        
        guard let remoteURL = generalFileObject?.url else {
            print("❌ No generalFileObject exist")
            return
        }
        
        Alamofire.request(remoteURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseData { [weak self] dataResponse in
            
            guard let data = dataResponse.data, dataResponse.error == nil else {
                return
            }
            
            let tmpURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            
            do {
                try data.write(to: tmpURL)
            } catch {
                print("❌ write to temp URL failed")
            }
            
            self?.localURLSubject.onNext(tmpURL)
        }
    }
}


