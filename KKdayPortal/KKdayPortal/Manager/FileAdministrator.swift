//
//  FileAdministrator.swift
//  KKdayPortal
//
//  Created by KKday on 2020/12/21.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

struct FileAdministrator {
    
    let baseURL: URL
    let path: String?
    
    private var baseURLPath: URL {
        var fileURL: URL = baseURL
        if let path = path {
            fileURL = fileURL.appendingPathComponent(path)
        }
        return fileURL
    }
    
    init?(baseURL: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, path: String? = nil) {
        
        guard let url = baseURL else {
            print("🗄❌ init FileAdministrator failed")
            return nil
        }
        self.baseURL = url
        self.path = path
    }
    
    func createDirectory(withName folderName: String) -> Bool {
        
        var fileURL: URL = baseURLPath
        fileURL = fileURL.appendingPathComponent(folderName)
        
        do {
            try FileManager.default.createDirectory(at: fileURL, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            print("🗄⚠️ create directory \(folderName) failed, error: \(error)")
            return false
        }
    }
    
    
    func writeTextFile(withName fileName: String, fileContent: String, canOverwrite: Bool) -> Bool {
        
        if checkPathExist(withName: fileName) && !canOverwrite {
            print("🗄⚠️ file \(fileName) is already exist")
            return false
        }
        
        var fileURL: URL = baseURLPath
        fileURL = fileURL.appendingPathComponent(fileName)
        
        do {
            try fileContent.write(to: fileURL, atomically: false, encoding: .utf8)
            return true
        } catch {
            print("🗄⚠️ create textFile \(fileName) failed, error: \(error)")
            return false
        }
    }
    
    func readTextFile(withName fileName: String) -> String? {
        
        var fileURL: URL = baseURLPath
        fileURL = fileURL.appendingPathComponent(fileName)
        
        do {
            let text = try String(contentsOf: fileURL)
            return text
            
        } catch {
            print("🗄⚠️ read textFile \(fileName) failed, error: \(error)")
            return nil
        }
    }
    
    func removeFile(withName fileName: String) -> Bool {
        
        var fileURL: URL = baseURLPath
        fileURL = fileURL.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            return true
        } catch {
            print("🗄⚠️ remove file \(fileName) failed, error: \(error)")
            return false
        }
    }
    
    func removeDirectory(withName folderName: String) {
        
        var fileURL: URL = baseURLPath
        fileURL = fileURL.appendingPathComponent(folderName)
       
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("🗄⚠️ remove directory \(folderName) failed, error: \(error)")
        }
    }
    
    func listFileNames() -> [String]? {
        
        let fileURL: URL = baseURLPath
        
        do {
            let fileNames = try FileManager.default.contentsOfDirectory(atPath: fileURL.path)
            return fileNames
        } catch {
            print("🗄⚠️ list file names \(path ?? "document") failed, error: \(error)")
            return nil
        }
    }
    
    func getAbsolutePath(withName fileName: String? = nil) -> URL? {
        
        if !checkPathExist(withName: fileName) {
            return nil
        }
        
        var fileURL: URL = baseURLPath
        if let fileName = fileName {
            fileURL = fileURL.appendingPathComponent(fileName)
        }
        
        return fileURL
    }
    
    func checkPathExist(withName fileName: String? = nil) -> Bool {
        
        var fileURL: URL = baseURLPath
        if let fileName = fileName {
            fileURL = fileURL.appendingPathComponent(fileName)
        }
    
        if FileManager.default.fileExists(atPath: fileURL.path) {
            print("🗄✅ great! path exists")
            return true
        } else {
            print("🗄⚠️ Opps! path not exists")
            return false
        }
    }
    
}
