//
//  ThemeHelper.swift
//  tips
//
//  Created by Kristy Caster on 6/26/16.
//  Copyright (c) 2016 kristeaac. All rights reserved.
//

import Foundation
import UIKit

let themes = [
    "yellow": Theme(name: "yellow", primaryColor: ThemeHelper.UIColorFromHex(0xFCBD31), secondaryColor: ThemeHelper.UIColorFromHex(0xFEE4A4)),
    "green": Theme(name: "green", primaryColor: ThemeHelper.UIColorFromHex(0x66AD63), secondaryColor: ThemeHelper.UIColorFromHex(0x9BE098)),
    "blue": Theme(name: "blue", primaryColor: ThemeHelper.UIColorFromHex(0x339AB5), secondaryColor: ThemeHelper.UIColorFromHex(0xABD6E1))
]

struct ThemeHelper {
    
    static func getTheme(theme: String) -> Theme! {
        return themes[theme]
    }
    
    static func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
}
