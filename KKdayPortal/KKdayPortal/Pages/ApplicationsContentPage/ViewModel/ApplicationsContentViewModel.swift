//
//  ApplicationsContentViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/18.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//

import RxSwift
import RxCocoa

final class ApplicationsContentViewModel: RXViewModelType, PortalControllable {
    
    typealias PortalContent = GeneralItem
    
    var input: ApplicationsContentViewModel.Input
    var output: ApplicationsContentViewModel.Output
    
    struct Input {
        let title: AnyObserver<String>
        let loadWebView: AnyObserver<URL?>
    }
    
    struct Output {
        let showTitle: Driver<String>
        let showLoadWebView: Driver<URL?>
    }
    
    private let titleSubject = PublishSubject<String>()
    private let loadWebViewSubject = PublishSubject<URL?>()
    
    var source: URL
    private let disposeBag = DisposeBag()
    var generalItem: PortalContent?
    
    init(source: URL) {
        self.source = source
        
        self.input = Input(title: titleSubject.asObserver(), loadWebView: loadWebViewSubject.asObserver()
        )
        
        self.output = Output(showTitle: titleSubject.asDriver(onErrorJustReturn: "Application"), showLoadWebView: loadWebViewSubject.asDriver(onErrorJustReturn: nil)
        )
    }
    
    func getPortalData() {
        
        // Plone BPM's remoteUrl String can't be parsed to URL
        #if SIT_VERSION
            let url = URL(string: "https://sit.eip.kkday.net/Plone/zh-tw/02-all-services/bpm")!
        
            if self.source == url {
                guard let generalUser: GeneralUser = StorageManager.shared.loadObject(for: .generalUser)
                else {
                    return
                }
                let account = generalUser.account

                let redirectUrl = URL(string: "http://sit.bpm.eip.kkday.net/WebAgenda/sso_index1.jsp?SearchableText=\(account)")!
                
                self.titleSubject.onNext("sit-BPM")
                self.loadWebViewSubject.onNext(redirectUrl)
                
                return
            }
           
        #elseif PRODUCTION_VERSION
            let url = URL(string: "https://eip.kkday.net/Plone/zh-tw/02-all-services/bpm")!
        
            if self.source == url {
                guard let generalUser: GeneralUser = StorageManager.shared.loadObject(for: .generalUser)
                    else {
                        return
                }
                let account = generalUser.account
                
                let redirectUrl = URL(string: "http://bpm.eip.kkday.net/WebAgenda/sso_index1.jsp?SearchableText=\(account)")!
                
                self.titleSubject.onNext("BPM")
                self.loadWebViewSubject.onNext(redirectUrl)
                
                return
            }
        
        #else
        
        #endif
        
          
                // https://sit.eip.kkday.net/Plone/zh-tw/02-all-services/bpm
                         
        //                    print(url)
        //                    print(url.host)
        //                    switch url.host {
        //                    case "sit.eip.kkday.net":
        //                        url = URL(string: "http://sit.bpm.eip.kkday.net/WebAgenda/sso_index1.jsp?SearchableText=\(userEmail)")!
        //
        //                    case "eip.kkday.net":
        //                        url = URL(string: "http://bpm.eip.kkday.net/WebAgenda/sso_index1.jsp?SearchableText=\(userEmail)")!
        //
        //                    default:
        //                        break
        //                    }
                
        
        ModelLoader.PortalLoader()
            .getItem(source: source, type: .link)
            .subscribeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] generalItem in
                
                self?.generalItem = generalItem
                if let title = generalItem.title {
                    self?.titleSubject.onNext(title)
                }
                
                if let linkObject = generalItem.linkObject {
                    let url = linkObject.url
                    self?.loadWebViewSubject.onNext(url)
                }
                
            }) { error in
                print("🚨 Func: \(#file),\(#function)")
                print("Error: \(error)")
        }
        .disposed(by: disposeBag)
    }
    
}
