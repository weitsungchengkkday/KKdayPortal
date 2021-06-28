//
//  FileNameProtocol.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/3/9.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

protocol FileNameProtocol {
    var fileName: String { get }
}

struct FileName: FileNameProtocol {

    var fileName: String

    init(string: String) {
        fileName = string
    }
}
