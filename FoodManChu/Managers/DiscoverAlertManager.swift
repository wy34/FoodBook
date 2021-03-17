//
//  File.swift
//  FoodManChu
//
//  Created by William Yeung on 3/17/21.
//

import UIKit

class DiscoverAlertManager {
    static let shared = DiscoverAlertManager()
    
    var isFirstTimeViewingDiscoverPage: Bool {
        return !UserDefaults.standard.bool(forKey: "firstTimeSeeingDiscover")
    }
    
    func setAsOldUser() {
        UserDefaults.standard.setValue(true, forKey: "firstTimeSeeingDiscover")
    }
}
