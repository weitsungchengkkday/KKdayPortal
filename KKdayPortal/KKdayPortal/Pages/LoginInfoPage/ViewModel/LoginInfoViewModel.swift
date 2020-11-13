//
//  LoginInfoViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/18.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

//import RxSwift
//import RxCocoa
//import Foundation
//
//final class LoginInfoViewModel: ViewModelType {
//    
//    private let disposeBag = DisposeBag()
//    
//    var input: LoginInfoViewModel.Input
//    var output: LoginInfoViewModel.Output
//    
//    struct Input {
//        let isEnterTextCorrect: AnyObserver<Bool>
//    }
//    
//    struct Output {
//        let showIsEnterTextCorrect: Driver<Bool>
//    }
//    
//    let isEnterTextCorrectSubject = PublishSubject<Bool>()
//    
//    init() {
//        self.input = Input(isEnterTextCorrect: isEnterTextCorrectSubject.asObserver())
//        self.output = Output(showIsEnterTextCorrect: isEnterTextCorrectSubject.asDriver(onErrorJustReturn: false))
//    }
//}
