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
                    
                    _odooModel = try decoder.decode([ConfigModel].self, from: data)[0]
                    
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
    
    
    private init() {
        
    }
    
    func setup() {
        let serverEnv: ServerEnv
        if let serverConfig: String = StorageManager.shared.load(for: .serverEnv),
            let env: ServerEnv = ServerEnv(rawValue: serverConfig) {
            serverEnv = env
            print("🎆 load SSO Plone server: \(serverEnv.rawValue)")
            
        } else {
            
            #if SIT
                        serverEnv = .sit
            #elseif PRODUCTION
                        serverEnv = .production
            #else
                        serverEnv = .local
            #endif
            
        
            StorageManager.shared.save(for: .serverEnv, value: serverEnv.rawValue)
            print("🎇 Set up SSO Plone signin server: \(serverEnv.rawValue)")
        }
        
        switch serverEnv {
        case .sit:
            odooModel.host = odooModel.sitServer
             
        case .production:
            odooModel.host = odooModel.productionServer
        case .local:
            odooModel.host = odooModel.localServer
        }
    }
    
}

