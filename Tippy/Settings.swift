//
//  Settings.swift
//  Tippy
//
//  Created by Jonathan Como on 8/31/16.
//  Copyright © 2016 Jonathan Como. All rights reserved.
//

import Foundation

struct Settings {
    static let rememberTip = StoredProperty<Bool>(
        withKey: "Tippy__rememberTip",
        getter: { (defaults, key) -> Bool in
            defaults.boolForKey(key)
        },
        setter: { (defaults, key, value) in
            defaults.setBool(value, forKey: key)
        
        }
    )
    
    static let tipIndex = StoredProperty<Int>(
        withKey: "Tippy__tipIndex",
        getter: { (defaults, key) -> Int in
            defaults.integerForKey(key)
        },
        setter: { (defaults, key, value) in
            defaults.setInteger(value, forKey: key)
        }
    )
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