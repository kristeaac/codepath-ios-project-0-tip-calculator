//
//  SettingsViewController.swift
//  tips
//
//  Created by Kristy Caster on 6/25/16.
//  Copyright (c) 2016 caster. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var defaultTipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultTipControl.selectedSegmentIndex = defaultTipIndex()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        defaultTipControl.selectedSegmentIndex = defaultTipIndex()
    }
    
    private func defaultTipIndex() -> Int {
        switch SettingsHelper.getDefaultTipPercentage() {
        case 0.18:
            return 0
        case 0.2:
            return 1
        case 0.22:
            return 2
        default:
            return 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func onValueChanged(sender: AnyObject) {
        SettingsHelper.setDefaultTipPercentage(tipPercentage())
    }
    
    private func tipPercentage() -> Double {
        var tipPercentages = [0.18, 0.2, 0.22]
        return tipPercentages[defaultTipControl.selectedSegmentIndex]
    }

}
