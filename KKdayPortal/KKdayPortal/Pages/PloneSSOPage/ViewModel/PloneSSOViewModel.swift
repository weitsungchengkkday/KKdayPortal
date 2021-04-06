//
//  PloneSSOViewModel.swift
//  KKdayPortal
//
//  Created by KKday on 2021/4/6.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import Foundation
import DolphinHTTP

final class PloneSSOViewModel {
    
    var portalservices: [PortalService] = []
    
    /// Load portal services remote
    
    func getPortalServicesRemote(completion: @escaping (([HTTPError]) -> Void)) {
        LoadingManager.shared.setState(state: .normal(value: true))
        PortalServiceAPI(loader: URLSessionLoader()).loadPortalService { [weak self] result in
        
            switch result {
            case .success(let services):
                self?.portalservices = services
                self?.getServiceElements { errors in
                    completion(errors)
                }
                
                DispatchQueue.main.async {
                    LoadingManager.shared.setState(state: .normal(value: false))
                }
                
            case .failure(let error):
                print("Load Portal Services Error: \(error)")
                completion([error])
                
                DispatchQueue.main.async {
                    LoadingManager.shared.setState(state: .normal(value: false))
                }
                break
            }
            
        }
    }
    
    private func getServiceElements(completion: @escaping (( [HTTPError]) -> Void)) {
        
        let group = DispatchGroup()
        
        var errors: [HTTPError] = []
        
        for service in self.portalservices {
            
            group.enter()
            PortalServiceElementAPI(loader: URLSessionLoader()).loadPortalServiceElement(serviceID: service.id) { result in
            
                switch result {
                case .success(let response):
                    let index = self.portalservices.firstIndex { $0.id == service.id }
                    
                    if index == nil {
                        print("❌ cant get portal service index")
                        return
                    }
                    
                    self.portalservices[index!].elements = response
                    
                case .failure(let error):
                    print("❌ get portal service element failed. \(error)")
                    errors.append(error)
                }
                group.leave()
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            
            for service in self.portalservices {
                
                switch service.name {
                case "Plone":
                    StorageManager.shared.saveObject(for: .plonePortalService, value: service)
                    print(service)
                case "Twilio":
                    StorageManager.shared.saveObject(for: .twilioPortalService, value: service)
                    print(service)
                default:
                    break
                }
            }
        
            completion(errors)
        }
        
    }
    
    /// Load portal services local
    func getPortalServicesLocal(completion: @escaping (([Error]) -> Void)) {
        
        let host = ConfigManager.shared.odooModel.host
        
        if let url = URL(string: host + "/portal_service") {
            
            do {
                let data = try Data(contentsOf: url)
                let services = try JSONDecoder().decode([PortalService].self, from: data)
                self.portalservices = services
                self.getServiceElementsLocal { (errors) in
                    completion(errors)
                }
             
            } catch {
                completion([error])
            }
        }
    }
    
    
    private func getServiceElementsLocal(completion: @escaping (( [Error]) -> Void)) {
        
        let group = DispatchGroup()
        
        var errors: [Error] = []
        
        for service in self.portalservices {
            
            group.enter()
            
            let host = ConfigManager.shared.odooModel.host
            
            if let url = URL(string: host + "/portal_service" + "/\(service.id)" +  "/portal_service_element") {
                
                do {
                    let data = try Data(contentsOf: url)
                    let response = try JSONDecoder().decode([PortalServiceElement].self, from: data)
                    
                    let index = self.portalservices.firstIndex { $0.id == service.id }
                    
                    if index == nil {
                        print("❌ cant get portal service index")
                        return
                    }
                    
                    self.portalservices[index!].elements = response
                    group.leave()
                } catch {
                    errors.append(error)
                    completion([error])
                }
            }
       
        }
        
        group.notify(queue: DispatchQueue.main) {
            
            for service in self.portalservices {
                
                switch service.name {
                case "Plone":
                    StorageManager.shared.saveObject(for: .plonePortalService, value: service)
                    print(service)
                case "Twilio":
                    StorageManager.shared.saveObject(for: .twilioPortalService, value: service)
                    print(service)
                default:
                    break
                }
            }
        
            completion(errors)
        }
        
    }
    
}
