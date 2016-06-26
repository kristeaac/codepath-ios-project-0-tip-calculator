//
//  ViewController.swift
//  tips
//
//  Created by Kristy Caster on 6/25/16.
//  Copyright (c) 2016 caster. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {

    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tipLabel.text = localCurrency(0.0)
        totalLabel.text = localCurrency(0.0)
        tipControl.selectedSegmentIndex = defaultTipIndex()
        setupBillAmount()
        calculateTip()
    }
    
    private func setupBillAmount() {
        let now = NSDate()
        let lastLoaded = SettingsHelper.getLastLoaded()
        var billAmount = ""
        if lastLoaded != nil && now.timeIntervalSinceDate(lastLoaded) / 60 < 10 {
            billAmount = String(format: "%.2f", SettingsHelper.getBillAmount())
        }
        billField.text = billAmount
        billField.becomeFirstResponder()
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
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        SettingsHelper.setBillAmount(billAmount())
        SettingsHelper.markLastLoaded()
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
        var amount = billAmount()
        var tip = amount * tipPercentage()
        var total = amount + tip
        
        tipLabel.text = localCurrency(tip)
        totalLabel.text = localCurrency(total)
    }
    
    private func localCurrency(amount: Double) -> String {
        var formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = NSLocale.currentLocale()
        return formatter.stringFromNumber(amount)!
    }
    
    private func billAmount() -> Double {
        return NSString(string: billField.text!).doubleValue
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}

