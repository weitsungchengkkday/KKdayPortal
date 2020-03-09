//
//  FilesManager.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/3/9.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

struct FilesManager {
    
    static func getFileURL(fileName: FileNameProtocol) -> URL? {
      
        do {
            let fileManager = FileManager.default
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            return documentDirectory.appendingPathComponent(fileName.fileName)
        } catch let error {
            print("get file failed, error: \(error)")
            return nil
        }
    }
    
    /// isFileExists
    static func isFileExists(fileName: FileNameProtocol) -> Bool {
        return isFileExists(url: getFileURL(fileName: fileName))
    }
    
    static func isFileExists(url: URL?) -> Bool {
        
        let fileManager = FileManager.default
        guard let url = url else {
            return false
        }
        
        return fileManager.fileExists(atPath: url.path)
    }
    
    /// Load File
    static func loadFile(fileName: FileNameProtocol) -> Data? {
        
        guard let url = getFileURL(fileName: fileName) else {
            return nil
        }
        
        return loadFile(url: url)
    }
    
    static func loadFile(url: URL) -> Data? {
        
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch let error {
            print("load file fail, error: \(error)")
            return nil
        }
    }
    
    /// saveFile
    static func saveFile(fileName: FileNameProtocol, base64: String) {
       
        guard let url = getFileURL(fileName: fileName) else {
            return
        }
        
        guard let data: Data = Data(base64Encoded: base64, options: [Data.Base64DecodingOptions.ignoreUnknownCharacters]) else {
            return
        }
        
        do {
            try data.write(to: url, options: .atomic)
            
        } catch let error {
            print("save file fail ,error: \(error)")
        }
    }
    
    static func saveFile(fileName: FileNameProtocol, pureText: String) {
        
        guard let url = getFileURL(fileName: fileName) else {
            return
        }
        
        do {
            try pureText.write(to: url, atomically: true, encoding: .utf8)
            
        } catch let error {
            print("save pureText file fail ,error: \(error)")
        }
    }
}
