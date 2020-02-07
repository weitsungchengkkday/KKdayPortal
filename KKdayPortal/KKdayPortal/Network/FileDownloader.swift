//
//  FileDownloader.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/2/6.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import Alamofire

final class FileDownloader {
    
    class func load(from remoteURL: URL, to localURL: URL) {
        
        guard let user: GeneralUser = StorageManager.shared.loadObject(for: .generalUser) else {
            print("❌ No generalUser exist")
            return
        }
        print(remoteURL)
        
        let token = user.token
        
        print(token)
        let headers: [String : String] = [
           "Authorization" : "Bearer" + " " + token
        ]
        
        //Alamofire.download(url, method: .get, parameters: nil, encoding: URLEncoding.defa
//        Alamofire.download(remoteURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, to: nil).responseData { (response) in
//            print(response.temporaryURL)
//            print(response.response)
//        }
        
        
        Alamofire.download(remoteURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers, to: nil).response { response in
            print(response.response?.statusCode)
            //      print(response.response?.allHeaderFields)
            
            guard response.error == nil else {
                print("❌, Download file error, \(response.error)")
                return
            }
            
            print("destinationURL: ")
            print(response.destinationURL)
            print("temporaryURL: ")
            print(response.temporaryURL)
            
            do {
                try FileManager.default.removeItem(at: localURL)
            } catch {
                print(error)
            }
            
            
            if let tempURL = response.temporaryURL {
                do {
                    try FileManager.default.copyItem(at: tempURL, to: localURL)
                } catch(let writeError) {
                    print("❌ FileManager, write file failed, \(writeError)")
                }
                
            } else {
                print("❌, No temporary URL exist")
            }
            
            
            
            
            
        }
        

    }
}
