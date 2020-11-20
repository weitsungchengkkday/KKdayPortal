//
//  LoadingViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/12/31.
//  Copyright © 2019 WEI-TSUNG CHENG. All rights reserved.
//
import UIKit
import Foundation

final class LoadingViewModel {
    
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
    
    
    private(set) var image: UIImage = #imageLiteral(resourceName: "icPicture")
    private(set) var title: (String, Bool) = ("Loading", true)
    
    var updateContent: () -> Void = {}

    init(state: UIState<Bool>) {

        self.state = state
    }
    
    func loadImageAndTitle() {
    
        switch state {
        case .normal:
            image = loadingImage
            title = ("", true)
            
        case .success(value: _, message: let message, duration: _, completion: _):
            image = successImage
            title = (message, false)
            
        case .error(value: _, message: let message, duration: _, completion: _):
           image = failImage
            title = (message, false)
        }
        
        updateContent()
    }
}
 
