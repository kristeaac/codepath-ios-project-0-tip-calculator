//
//  SettingsHelper.swift
//  tips
//
//  Created by Kristy Caster on 6/25/16.
//  Copyright (c) 2016 caster. All rights reserved.
//

import Foundation

private let defaultTipPercentageKey: String = "default_tip_percentage"
private let billAmountKey: String = "bill_amount"
private let lastLoadedKey: String = "last_loaded"
private let themeKey: String = "theme"
private let defaultSplitKey: String = "default_split"

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
    
    static func setBillAmount(billAmount: Double) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setDouble(billAmount, forKey: billAmountKey)
        defaults.synchronize()
    }
    
    static func getBillAmount() -> Double {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.doubleForKey(billAmountKey)
    }
    
    static func markLastLoaded() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(NSDate(), forKey: lastLoadedKey)
        defaults.synchronize()
    }
    
    static func getLastLoaded() -> NSDate! {
        let defaults = NSUserDefaults.standardUserDefaults()
        let blah = defaults.objectForKey(lastLoadedKey) as? NSDate
        return blah
    }
    
    static func setTheme(theme: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(theme, forKey: themeKey)
        defaults.synchronize()
    }
    
    static func getTheme() -> String! {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.stringForKey(themeKey)
    }
    
    static func setDefaultSplit(split: Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(split, forKey: defaultSplitKey)
        defaults.synchronize()
    }
    
    static func getDefaultSplit() -> Int {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.integerForKey(defaultSplitKey)
    }
    
}
