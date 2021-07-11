//
//  File.swift
//  FoodManChu
//
//  Created by William Yeung on 3/17/21.
//

import UIKit

class DiscoverAlertManager {
    // MARK: - Properties
    static let shared = DiscoverAlertManager()
    private let key = "firstTimeSeeingDiscover"
    
    var isFirstTimeViewingDiscoverPage: Bool {
        return !UserDefaults.standard.bool(forKey: key)
    }
    
    // MARK: - Helpers
    func setAsOldUser() {
        UserDefaults.standard.setValue(true, forKey: key)
    }
}
