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
    
    private(set) var odooModel: ConfigModel {
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
    
    var serverEnv: ServerEnv {
        if let serverConfig: String = StorageManager.shared.load(for: .serverEnv),
            let env: ServerEnv = ServerEnv(rawValue: serverConfig) {
            return env
            
        } else {
            #if SIT
            return .sit
            #elseif PRODUCTION
            return .production
            #else
            return .local
            #endif
        }
    }
    
    private init() {
        
    }
    
    func setup() {
        let serverEnv = self.serverEnv
    
        switch serverEnv {
        case .sit:
            odooModel.host = odooModel.sitServer
            odooModel.client = odooModel.sitClientID
             
        case .production:
            odooModel.host = odooModel.productionServer
            odooModel.client = odooModel.productionClientID
            
        case .local:
            odooModel.host = odooModel.localServer
            odooModel.client = odooModel.localClientID
        }
    }
    
}

