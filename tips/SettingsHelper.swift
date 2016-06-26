//
//  SettingsHelper.swift
//  tips
//
//  Created by Kristy Caster on 6/25/16.
//  Copyright (c) 2016 caster. All rights reserved.
//

import Foundation

private let defaultTipPercentageKey: String = "default_tip_percentage"

struct SettingsHelper {
    
    static func setDefaultTipPercentage(defaultTipPercentage: Double) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setDouble(defaultTipPercentage, forKey: defaultTipPercentageKey)
        defaults.synchronize()
    }
    
    static func getDefaultTipPercentage() -> Double {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.doubleForKey(defaultTipPercentageKey)
    }
    
}
