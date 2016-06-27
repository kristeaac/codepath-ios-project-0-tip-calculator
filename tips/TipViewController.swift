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
    @IBOutlet weak var fieldsView: UIView!
    @IBOutlet weak var tipLabelLabel: UILabel!
    @IBOutlet weak var totalLabelLabel: UILabel!
@IBOutlet weak var eachTextLabel: UILabel!
    @IBOutlet weak var settingsButtonItem: UIBarButtonItem!
@IBOutlet weak var eachLabel: UILabel!
    
    // constraints
    @IBOutlet weak var tipControlYConstraint: NSLayoutConstraint!
    @IBOutlet weak var tipTextYConstraint: NSLayoutConstraint!
    @IBOutlet weak var tipLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalTextLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var fieldsViewYConstraint: NSLayoutConstraint!
    @IBOutlet weak var eachLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var eachTextLabelYConstraint: NSLayoutConstraint!
    
    var yConstants = [NSLayoutConstraint:CGFloat]()
    
    // original Y positions
    var tipControlYConstant: CGFloat!
    var tipTextYConstant: CGFloat!
    var tipLabelYConstant: CGFloat!
    var totalTextLabelYConstant: CGFloat!
    var totalLabelYConstant: CGFloat!
    var fieldsViewYConstant: CGFloat!
    var eachTextLabelYConstant: CGFloat!
    var eachLabelYConstant: CGFloat!

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

    private func hideFields() {
        var yConstraints = [
            tipControlYConstraint,
            tipTextYConstraint,
            tipLabelYConstraint,
            totalTextLabelYConstraint,
            totalLabelYConstraint,
            fieldsViewYConstraint,
            eachLabelYConstraint,
            eachTextLabelYConstraint
        ]
        for yConstraint in yConstraints {
            yConstants[yConstraint] = yConstraint.constant
            yConstraint.constant = self.view.bounds.size.height
        }
    }
    
    private func revealFields() {
        UIView.animateWithDuration(0.5) {
            for (constraint, constant) in self.yConstants {
                constraint.constant = constant
            }
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
        updateScreenTheme()
    }
    
    private func updateScreenTheme() {
        var selectedTheme = ThemeHelper.getTheme(SettingsHelper.getTheme())
        if selectedTheme != nil {
            view.backgroundColor = selectedTheme.secondaryColor
            billField.textColor = selectedTheme.primaryColor
            fieldsView.backgroundColor = selectedTheme.primaryColor
            tipLabel.textColor = selectedTheme.secondaryColor
            totalLabel.textColor = selectedTheme.secondaryColor
            tipLabelLabel.textColor = selectedTheme.secondaryColor
            eachLabel.textColor = selectedTheme.secondaryColor
            eachTextLabel.textColor = selectedTheme.secondaryColor
            totalLabelLabel.textColor = selectedTheme.secondaryColor
            tipControl.tintColor = selectedTheme.secondaryColor
            settingsButtonItem.tintColor = selectedTheme.primaryColor
            self.navigationController?.navigationBar.tintColor = selectedTheme.primaryColor
        }
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

