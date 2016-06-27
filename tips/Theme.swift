//
//  Theme.swift
//  tips
//
//  Created by Kristy Caster on 6/26/16.
//  Copyright (c) 2016 kristeaac. All rights reserved.
//

import Foundation
import UIKit

class Theme {
    var primaryColor: UIColor
    var secondaryColor: UIColor
    var name: String
    
    init(name: String, primaryColor: UIColor, secondaryColor: UIColor) {
        self.name = name
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
    }
    
}
