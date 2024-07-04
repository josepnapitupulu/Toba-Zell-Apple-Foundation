//
//  DataManager.swift
//  ZellTob
//
//  Created by Foundation-013 on 03/07/24.
//

import Foundation

class DataManager {
    // get
    static var isCard1Open = UserDefaults.standard.bool(forKey: "isCard1Open")
    static var isCard2Open = UserDefaults.standard.bool(forKey: "isCard2Open")
    static var isCard3Open = UserDefaults.standard.bool(forKey: "isCard3Open")
    static var isCard4Open = UserDefaults.standard.bool(forKey: "isCard4Open")
    static var isCard5Open = UserDefaults.standard.bool(forKey: "isCard5Open")
    
    static func openCard1() {
        // set
        UserDefaults.standard.set(true, forKey: "isCard1Open")
    }
    
    static func openCard2() {
        // set
        UserDefaults.standard.set(true, forKey: "isCard2Open")
    }
    
    static func openCard3() {
        // set
        UserDefaults.standard.set(true, forKey: "isCard3Open")
    }
    
    static func openCard4() {
        // set
        UserDefaults.standard.set(true, forKey: "isCard4Open")
    }
    
    static func openCard5() {
        // set
        UserDefaults.standard.set(true, forKey: "isCard5Open")
    }
}
