//
//  NetworkManager.swift
//  FoodManChu
//
//  Created by William Yeung on 3/13/21.
//

import UIKit
import Network
import SwiftUI


class NetworkManager: ObservableObject {
    @Published var isConnectedToInternet = false // just to default it to that
    
    static let shared = NetworkManager()
    
    // observes changes in network connect
    let monitor = NWPathMonitor()
    
    // respond to different changes in connectivity
    func setupNetworkMonitor() {
        monitor.pathUpdateHandler = { [unowned self] path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    print("connected")
                    self.isConnectedToInternet = true
                } else {
                    print("not connected")
                    self.isConnectedToInternet = false
                }
            }
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}
