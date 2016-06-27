//
//  ViewController.swift
//  tips
//
//  Created by Kristy Caster on 6/25/16.
//  Copyright (c) 2016 caster. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {

    // views
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    // constraints
    @IBOutlet weak var tipControlYConstraint: NSLayoutConstraint!
    @IBOutlet weak var tipTextYConstraint: NSLayoutConstraint!
    @IBOutlet weak var tipLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalTextLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var fieldsViewYConstraint: NSLayoutConstraint!
   
    // original Y positions
    var tipControlYConstant: CGFloat!
    var tipTextYConstant: CGFloat!
    var tipLabelYConstant: CGFloat!
    var totalTextLabelYConstant: CGFloat!
    var totalLabelYConstant: CGFloat!
    var fieldsViewYConstant: CGFloat!

    var needToRevealFields = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tipLabel.text = localCurrency(0.0)
        totalLabel.text = localCurrency(0.0)
        tipControl.selectedSegmentIndex = defaultTipIndex()
        setupBillAmount()
        calculateTip()
        if billAmount() == 0.0 {
            hideFields()
            needToRevealFields = true
        }
        //self.view.backgroundColor = UIColorFromHex(0xffffff)
        
    }
    
    private func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }

    private func hideFields() {
        tipControlYConstant = tipControlYConstraint.constant
        tipControlYConstraint.constant = self.view.bounds.size.height
        
        tipTextYConstant = tipTextYConstraint.constant
        tipTextYConstraint.constant = self.view.bounds.size.height
        
        tipLabelYConstant = tipLabelYConstraint.constant
        tipLabelYConstraint.constant = self.view.bounds.size.height
        
        totalTextLabelYConstant = totalTextLabelYConstraint.constant
        totalTextLabelYConstraint.constant = self.view.bounds.size.height
        
        totalLabelYConstant = totalLabelYConstraint.constant
        totalLabelYConstraint.constant = self.view.bounds.size.height

        fieldsViewYConstant = fieldsViewYConstraint.constant
        fieldsViewYConstraint.constant = self.view.bounds.size.height

    }
    
    private func revealFields() {
        UIView.animateWithDuration(0.5) {
            self.tipControlYConstraint.constant = self.tipControlYConstant
            self.tipTextYConstraint.constant = self.tipTextYConstant
            self.tipLabelYConstraint.constant = self.tipLabelYConstant
            self.totalTextLabelYConstraint.constant = self.totalTextLabelYConstant
            self.totalLabelYConstraint.constant = self.totalLabelYConstant
            self.fieldsViewYConstraint.constant = self.fieldsViewYConstant

            self.view.layoutIfNeeded()
        }
    }
    
    private func setupBillAmount() {
        let now = NSDate()
        let lastLoaded = SettingsHelper.getLastLoaded()
        var amount = ""
        if lastLoaded != nil && now.timeIntervalSinceDate(lastLoaded) / 60 < 10 {
            if (SettingsHelper.getBillAmount() > 0.0) {
                amount = String(format: "%.2f", SettingsHelper.getBillAmount())
            }
        }
        billField.text = amount
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
        if needToRevealFields == true {
            revealFields()
        }
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

