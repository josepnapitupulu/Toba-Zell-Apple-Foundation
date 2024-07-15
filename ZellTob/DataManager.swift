//
//  DataManager.swift
//  ZellTob
//
//  Created by Foundation-013 on 03/07/24.
//

import Foundation

class DataManager {
    // get
    static var isCard1Open = UserDefaults.standard.bool(forKey: "isCard1Open") {
        didSet {
            NotificationCenter.default.post(name: .cardStatusDidChange, object: nil)
        }
    }
    static var isCard2Open = UserDefaults.standard.bool(forKey: "isCard2Open") {
        didSet {
            NotificationCenter.default.post(name: .cardStatusDidChange, object: nil)
        }
    }
    static var isCard3Open = UserDefaults.standard.bool(forKey: "isCard3Open") {
        didSet {
            NotificationCenter.default.post(name: .cardStatusDidChange, object: nil)
        }
    }
    static var isCard4Open = UserDefaults.standard.bool(forKey: "isCard4Open") {
        didSet {
            NotificationCenter.default.post(name: .cardStatusDidChange, object: nil)
        }
    }
    static var isCard5Open = UserDefaults.standard.bool(forKey: "isCard5Open") {
        didSet {
            NotificationCenter.default.post(name: .cardStatusDidChange, object: nil)
        }
    }
    
    static func openCard1() {
        // set
        UserDefaults.standard.set(true, forKey: "isCard1Open")
        isCard1Open = true
    }
    
    static func openCard2() {
        // set
        UserDefaults.standard.set(true, forKey: "isCard2Open")
        isCard2Open = true
    }
    
    static func openCard3() {
        // set
        UserDefaults.standard.set(true, forKey: "isCard3Open")
        isCard3Open = true
    }
    
    static func openCard4() {
        // set
        UserDefaults.standard.set(true, forKey: "isCard4Open")
        isCard4Open = true
    }
    
    static func openCard5() {
        // set
        UserDefaults.standard.set(true, forKey: "isCard5Open")
        isCard5Open = true
    }
}

extension Notification.Name {
    static let cardStatusDidChange = Notification.Name("cardStatusDidChange")
}
