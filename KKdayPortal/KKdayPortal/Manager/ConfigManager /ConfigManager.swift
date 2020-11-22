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
    
    fileprivate var _model: ConfigModel!
    
    var model: ConfigModel {
        get {
            if _model == nil {
                let name = "\(ConfigModel.self)"
                let path = Bundle.main.path(forResource: name, ofType: "json")!
                let url = URL(fileURLWithPath: path)
                
                do {
                    let data = try Data(contentsOf: url, options: Data.ReadingOptions.mappedIfSafe)
                    
                    let decoder = JSONDecoder()
                    _model = try decoder.decode(ConfigModel.self, from: data)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            
            return _model
        }
        
        set {
            _model = newValue
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
            serverType = .sit
#endif
            StorageManager.shared.save(for: .serverType, value: serverType.rawValue)
            print("🎇 Set up SSO Plone signin server: \(serverType.rawValue)")
        }
        
        switch serverType {
        case .sit:
            model.host = model.sitServer
            model.BPM = model.sitBPM
        case .production:
            model.host = model.productionServer
            model.BPM = model.productionBPM
        }

    }
    
}

