//
//  Settings.swift
//  Tippy
//
//  Created by Jonathan Como on 8/31/16.
//  Copyright © 2016 Jonathan Como. All rights reserved.
//

import Foundation

struct Settings {
    static let rememberTip = BoolProperty(key: "Tippy__rememberTip")
    static let tipIndex = IntProperty(key: "Tippy__tipIndex")
    static let lastBillAmount = DoubleProperty(key: "Tippy__lastBillAmount")
    static let lastBillTimestamp = DateProperty(key: "Tippy__lastBillTimestamp")
}

class DateProperty: StoredProperty<NSDate> {
    init(key: String) {
        super.init(
            withKey: key,
            getter: { (defaults, key) -> NSDate in
                (defaults.objectForKey(key) as? NSDate) ?? NSDate.distantPast()
            },
            setter: { (defaults, key, value) -> () in
                defaults.setObject(value, forKey: key)
            }
        )
    }
}

class DoubleProperty: StoredProperty<Double> {
    init(key: String) {
        super.init(
            withKey: key,
            getter: { (defaults, key) -> Double in
                defaults.doubleForKey(key)
            },
            setter: { (defaults, key, value) -> () in
                defaults.setDouble(value, forKey: key)
            }
        )
    }
}

class IntProperty: StoredProperty<Int> {
    init(key: String) {
        super.init(
            withKey: key,
            getter: { (defaults, key) -> Int in
                defaults.integerForKey(key)
            },
            setter: { (defaults, key, value) -> () in
                defaults.setInteger(value, forKey: key)
            }
        )
    }
}

class BoolProperty: StoredProperty<Bool> {
    init(key: String) {
        super.init(
            withKey: key,
            getter: { (defaults, key) -> Bool in
                defaults.boolForKey(key)
            },
            setter: { (defaults, key, value) -> () in
                defaults.setBool(value, forKey: key)
            }
        )
    }
}

class StoredProperty<T> {
    private var key: String
    private var getter: (NSUserDefaults, String) -> T
    private var setter: (NSUserDefaults, String, T) -> ()
    
    init(withKey
        key: String,
        getter: (NSUserDefaults, String) -> T,
        setter: (NSUserDefaults, String, T) -> ()) {
        
        self.key = key
        self.getter = getter
        self.setter = setter
    }
    
    func get() -> T {
        return withDefaults { defaults in
            self.getter(defaults, self.key)
        }
    }
    
    func set(value: T) {
        withDefaults { defaults in
            self.setter(defaults, self.key, value)
        }
    }
    
    func remove() {
        withDefaults { defaults in
            defaults.removeObjectForKey(self.key)
        }
    }
    
    private func withDefaults<V>(action: NSUserDefaults -> V) -> V {
        let defaults = NSUserDefaults.standardUserDefaults()
        let result = action(defaults)
        defaults.synchronize()
        return result
    }
}