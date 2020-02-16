//
//  GeneralCollectionIFrameContentTableViewCellViewModel.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/1.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import UIKit

final class GeneralTextObjectIFrameTableViewCellViewModel {
    let title: String
    let url: URL
    let size: CGSize?
    
    init(title: String, url: URL, size: CGSize? = nil) {
        self.title = title
        self.url = url
        self.size = size
    }
}
