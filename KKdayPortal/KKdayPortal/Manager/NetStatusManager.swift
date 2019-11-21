//
//  NetStatusManager.swift
//  KKdayPortal
//
//  Created by WEI-TSUNG CHENG on 2019/10/30.
//  Copyright © 2019 com.inventory.kkday.www. All rights reserved.
//
import Network

class NetStatusManager {
    
    static let shared = NetStatusManager()
    
    var monitor: NWPathMonitor?
    var isMonitor = false
    var isMonitoring = false
    
    var didStartMonitoringHandler: (() -> Void)?
    var didStopMonitoringHandler: (() -> Void)?
    var netStatusChangeHandler: (() -> Void)?
    
    private init() {
        
    }
    
    func startMonitoring() {
        guard !isMonitoring else {
            return
        }
        
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetStatus_Monitor")
        monitor?.start(queue: queue)
        // operate on background thread
        monitor?.pathUpdateHandler = { _ in
            self.netStatusChangeHandler?()
        }
        
        isMonitoring = true
        didStartMonitoringHandler?()
    }
    
    func stopMonitoring() {
        guard isMonitoring, let monitor = monitor else {
           return
        }
        monitor.cancel()
        self.monitor = nil
        isMonitoring = false
        didStopMonitoringHandler?()
    }
    
    deinit {
        stopMonitoring()
    }
    
    var isConnected: Bool {
        guard let monitor = monitor else {
            return false
        }
        return monitor.currentPath.status == .satisfied
    }
    
    var interfaceType: NWInterface.InterfaceType? {
        guard let monitor = monitor else { return nil }
    
        let interfaces: [NWInterface] = monitor.currentPath.availableInterfaces.filter { interface -> Bool in
            return monitor.currentPath.usesInterfaceType(interface.type)
        }
        return interfaces.first?.type
    }
    
    var availableInterfacesTypes: [NWInterface.InterfaceType]? {
        guard let monitor = monitor else { return nil }
        return monitor.currentPath.availableInterfaces.map { interface -> NWInterface.InterfaceType in
            return interface.type
        }
    }
    
    var isExpensive: Bool {
        return monitor?.currentPath.isExpensive ?? false
    }
}



