//
//  ConfigManager.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2020/1/20.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation

final class ConfigManager {
    static let shared: ConfigManager = ConfigManager()
    
    fileprivate var _odooModel: ConfigModel!
    fileprivate var _ploneModel: ConfigModel!
    
    var odooModel: ConfigModel {
        get {
            if _odooModel == nil {
                let name = "\(ConfigModel.self)"
                let path = Bundle.main.path(forResource: name, ofType: "json")!
                let url = URL(fileURLWithPath: path)
                
                do {
                    let data = try Data(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
                    
                    let decoder = JSONDecoder()
                    
                    _odooModel = try decoder.decode([ConfigModel].self, from: data)[1]
                    
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            
            return _odooModel
        }
        
        set {
            _odooModel = newValue
        }
    }
    
    var ploneModel: ConfigModel {
        get {
            if _ploneModel == nil {
                let name = "\(ConfigModel.self)"
                let path = Bundle.main.path(forResource: name, ofType: "json")!
                let url = URL(fileURLWithPath: path)
                
                do {
                    let data = try Data(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
                    
                    let decoder = JSONDecoder()
                    _ploneModel = try decoder.decode([ConfigModel].self, from: data)[0]
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            
            return _ploneModel
        }
        
        set {
            _ploneModel = newValue
        }
    }
    
    private init() {
        
    }
    
    func setup() {
        let serverType: ServerTypes
        if let serverConfig: String = StorageManager.shared.load(for: .serverType),
            let type: ServerTypes = ServerTypes(rawValue: serverConfig) {
            serverType = type
            print("🎆 load SSO Plone server: \(serverType.rawValue)")
            
        } else {
            
            
#if SIT
            serverType = .sit
#elseif PRODUCTION
            serverType = .production
#else
            fatalError("Server Type not exist")
#endif
            StorageManager.shared.save(for: .serverType, value: serverType.rawValue)
            print("🎇 Set up SSO Plone signin server: \(serverType.rawValue)")
        }
        
        switch serverType {
        case .sit:
            odooModel.host = odooModel.sitServer
            ploneModel.host = ploneModel.sitServer
             
        case .production:
            odooModel.host = odooModel.productionServer
            ploneModel.host = ploneModel.productionServer
          
        }

    }
    
}

