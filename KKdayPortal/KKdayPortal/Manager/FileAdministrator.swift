//
//  FileAdministrator.swift
//  KKdayPortal
//
//  Created by KKday on 2020/12/21.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//
//
import Foundation
import UIKit

extension FileManager {
    static var documentDirectoryURL: URL {
        `default`.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

struct FileAdministrator {
    func createDirectoryWithURL(withName documentName: String, withURL directoryURL: URL, withAttribute attributes: [FileAttributeKey: Any]? = nil) -> URL? {
        let documentURL = directoryURL.appendingPathComponent(documentName, isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: documentURL, withIntermediateDirectories: true, attributes: attributes)
            return documentURL
        } catch {
            print("🗄⚠️ create directory \(String(describing: documentURL)) failed, error: \(error)")
            return nil
        }
    }
    func createDirectoryAtPath(atPath path: String, withAttribute attributes: [FileAttributeKey: Any]? = nil) -> Bool {
        do {
            try
                FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: attributes)
            return true
        } catch {
            print("🗄⚠️ create directory with path \(path) failed, error: \(error)")
            return false
        }
    }
    func createFileAtPath(atPath path: String, withData data: Data?, withAttribute attributes: [FileAttributeKey: Any]? = nil) {
        FileManager.default.createFile(atPath: path, contents: data, attributes: attributes)
    }
    func removeFileWithURL(withName fileName: String, withExtension fileExtension: String, withURL directoryURL: URL) -> URL? {
        let fileURL = directoryURL
            .appendingPathComponent(fileName)
            .appendingPathExtension(fileExtension)
        do {
            try FileManager.default.removeItem(at: fileURL)
            return fileURL
        } catch {
            print("🗄⚠️ remove file \(fileName) failed, error: \(error)")
            return nil
        }
    }
    func removeFileAtPath(atPath path: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            print("🗄⚠️ remove file at path \(path) failed, error: \(error)")
            return false
        }
    }
    func removeDirectoryWithURL(withName documentName: String, withURL directoryURL: URL) -> URL? {
        let documentURL: URL = directoryURL.appendingPathComponent(documentName, isDirectory: true)
        do {
            try FileManager.default.removeItem(at: documentURL)
            return documentURL
        } catch {
            print("🗄⚠️ remove directory \(documentName) failed, error: \(error)")
            return nil
        }
    }
    func removeDirectoryAtPath(atPath path: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            print("🗄⚠️ remove directory at path \(path) failed, error: \(error)")
            return false
        }
    }
    func isFileExistAtPath(atPath path: String) -> Bool {
        if FileManager.default.fileExists(atPath: path) {
            print("🗄✅ great! path exists")
            return true
        } else {
            print("🗄⚠️ Opps! path not exists")
            return false
        }
    }
    func contentsOfDirectoryWithURL(withURL directoryURL: URL, withResource resource :[URLResourceKey]? = nil, withOption option: FileManager.DirectoryEnumerationOptions = []) -> [URL]? {
        do {
            let fileNames = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: resource, options: option)
            return fileNames
        } catch {
            print("🗄⚠️ list content of directory at URL \(directoryURL) failed, error: \(error)")
            return nil
        }
    }
    func contentsOfDirectoryAtPath(atPath path: String) -> [String]? {
        do {
            let fileNames = try FileManager.default.contentsOfDirectory(atPath: path)
            return fileNames
        } catch {
            print("🗄⚠️ list content of directory at path \(path) failed, error: \(error)")
            return nil
        }
    }
}
