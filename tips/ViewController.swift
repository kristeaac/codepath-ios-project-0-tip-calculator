//
//  ViewController.swift
//  tips
//
//  Created by Kristy Caster on 6/25/16.
//  Copyright (c) 2016 caster. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
        tipControl.selectedSegmentIndex = defaultTipIndex()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tipControl.selectedSegmentIndex = defaultTipIndex()
        calculateTip()
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


    @IBAction func onEditingChange(sender: AnyObject) {
        calculateTip()
    }
    
    private func tipPercentage() -> Double {
        var tipPercentages = [0.18, 0.2, 0.22]
        return tipPercentages[tipControl.selectedSegmentIndex]
    }
    
    private func calculateTip() {
        var billAmount = NSString(string: billField.text!).doubleValue
        var tip = billAmount * tipPercentage()
        var total = billAmount + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}

