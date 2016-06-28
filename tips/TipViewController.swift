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
    @IBOutlet weak var splitStepper: UIStepper!
    @IBOutlet weak var splitNumberLabel: UILabel!
    @IBOutlet weak var splitLabel: UILabel!
    
    // constraints
    @IBOutlet weak var tipControlYConstraint: NSLayoutConstraint!
    @IBOutlet weak var tipTextYConstraint: NSLayoutConstraint!
    @IBOutlet weak var tipLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalTextLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var fieldsViewYConstraint: NSLayoutConstraint!
    @IBOutlet weak var eachLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var eachTextLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var splitStepperYConstraint: NSLayoutConstraint!
    @IBOutlet weak var splitLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var splitNumberLabelYConstraint: NSLayoutConstraint!
    @IBOutlet weak var billFieldYConstraint: NSLayoutConstraint!

    var yConstants = [NSLayoutConstraint:CGFloat]()

    var needToRevealFields = false
    var originalBillFieldFontSize: CGFloat!

    override func viewDidLoad() {
        super.viewDidLoad()
        tipLabel.text = localCurrency(0.0)
        totalLabel.text = localCurrency(0.0)
        tipControl.selectedSegmentIndex = defaultTipIndex()
        setupSplit()
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
            eachTextLabelYConstraint,
            splitStepperYConstraint,
            splitLabelYConstraint,
            splitNumberLabelYConstraint,
            billFieldYConstraint
        ]
        for yConstraint in yConstraints {
            yConstants[yConstraint] = yConstraint.constant
            if (yConstraint == billFieldYConstraint) {
                yConstraint.constant = self.view.center.x
                originalBillFieldFontSize = billField.font.pointSize
                billField.font = billField.font.fontWithSize(120)
            } else {
                yConstraint.constant = self.view.bounds.size.height
            }
        }
    }
    
    private func revealFields() {
        UIView.animateWithDuration(0.5) {
            for (constraint, constant) in self.yConstants {
                constraint.constant = constant
            }
            self.billField.font = self.billField.font.fontWithSize(self.originalBillFieldFontSize)
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
    
    private func setupSplit() {
        var split = SettingsHelper.getDefaultSplit()
        if split == 0 {
            split = 1
        }
        splitStepper.value = Double(split)
        onSplitStepperValueChanged(splitStepper)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tipControl.selectedSegmentIndex = defaultTipIndex()
        setupSplit()
        calculateTip()
        updateScreenTheme()
    }
    
    private func updateScreenTheme() {
        var savedTheme = SettingsHelper.getTheme()
        if savedTheme != nil {
            var selectedTheme = ThemeHelper.getTheme(SettingsHelper.getTheme())
            if selectedTheme != nil {
                view.backgroundColor = selectedTheme.secondaryColor
                billField.textColor = selectedTheme.secondaryTextColor
                fieldsView.backgroundColor = selectedTheme.primaryColor
                tipLabel.textColor = selectedTheme.primaryTextColor
                totalLabel.textColor = selectedTheme.primaryTextColor
                tipLabelLabel.textColor = selectedTheme.primaryTextColor
                eachLabel.textColor = selectedTheme.primaryTextColor
                eachTextLabel.textColor = selectedTheme.primaryTextColor
                totalLabelLabel.textColor = selectedTheme.primaryTextColor
                tipControl.tintColor = selectedTheme.primaryTextColor
                splitStepper.tintColor = selectedTheme.primaryTextColor
                splitLabel.textColor = selectedTheme.primaryTextColor
                splitNumberLabel.textColor = selectedTheme.primaryTextColor
                self.navigationController?.navigationBar.tintColor = selectedTheme.secondaryTextColor
                settingsButtonItem.tintColor = selectedTheme.secondaryTextColor
            }
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
        var each = total / split()
        
        tipLabel.text = localCurrency(tip)
        totalLabel.text = localCurrency(total)
        eachLabel.text = localCurrency(each)
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

    @IBAction func onSplitStepperValueChanged(sender: UIStepper) {
        splitNumberLabel.text = Int(sender.value).description
        calculateTip()
    }
    
    private func split() -> Double {
        return splitStepper.value
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}

