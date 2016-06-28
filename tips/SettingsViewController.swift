//
//  SettingsViewController.swift
//  tips
//
//  Created by Kristy Caster on 6/25/16.
//  Copyright (c) 2016 caster. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    // views
    @IBOutlet weak var defaultTipControl: UISegmentedControl!
    @IBOutlet weak var yellowThemeButton: UIButton!
    @IBOutlet weak var greenThemeButton: UIButton!
    @IBOutlet weak var blueThemeButton: UIButton!
    @IBOutlet weak var defaultTipLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var defaultSplitLabel: UILabel!
    @IBOutlet weak var defaultSplitNumberLabel: UILabel!
    @IBOutlet weak var defaultSplitStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultTipControl.selectedSegmentIndex = defaultTipIndex()
        roundButton(yellowThemeButton)
        roundButton(greenThemeButton)
        roundButton(blueThemeButton)
    }
    
    private func roundButton(button: UIButton) {
        button.frame = CGRectMake(100, 100, 100, 100)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
    }
    
    private func round(view: UIView) {
        view.layer.cornerRadius = view.frame.size.width / 2
        view.clipsToBounds = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        defaultTipControl.selectedSegmentIndex = defaultTipIndex()
        updateScreenTheme()
        setupSplit()
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
    
    private func setupSplit() {
        var split = SettingsHelper.getDefaultSplit()
        if split == 0 {
            split = 1
        }
        defaultSplitStepper.value = Double(split)
        onDefaultSplitChanged(defaultSplitStepper)
    }
    
    @IBAction func onClick(sender: UIButton) {
        switch sender {
        case yellowThemeButton:
            setTheme("yellow")
        case greenThemeButton:
            setTheme("green")
        case blueThemeButton:
            setTheme("blue")
        default:
            println("unknown theme")
        }
        
    }
    
    private func setTheme(theme: String) {
        SettingsHelper.setTheme(theme)
        updateScreenTheme();
    }
    
    private func updateScreenTheme() {
        var savedTheme = SettingsHelper.getTheme()
        if savedTheme != nil {
            var selectedTheme = ThemeHelper.getTheme(SettingsHelper.getTheme())
            if selectedTheme != nil {
                view.backgroundColor = selectedTheme.primaryColor
                defaultTipLabel.textColor = selectedTheme.secondaryColor
                themeLabel.textColor = selectedTheme.secondaryColor
                defaultTipControl.tintColor = selectedTheme.secondaryColor
                defaultSplitLabel.textColor = selectedTheme.secondaryColor
                defaultSplitNumberLabel.textColor = selectedTheme.secondaryColor
                defaultSplitStepper.tintColor = selectedTheme.secondaryColor
                self.navigationController?.navigationBar.tintColor = selectedTheme.primaryColor
                switch selectedTheme.name {
                case "yellow":
                    selectThemeButton(yellowThemeButton)
                    deselectThemeButton(greenThemeButton)
                    deselectThemeButton(blueThemeButton)
                case "green":
                    selectThemeButton(greenThemeButton)
                    deselectThemeButton(yellowThemeButton)
                    deselectThemeButton(blueThemeButton)
                case "blue":
                    selectThemeButton(blueThemeButton)
                    deselectThemeButton(greenThemeButton)
                    deselectThemeButton(yellowThemeButton)
                default:
                    println("unknown theme name")
                }
            }
        }
    }
    
    private func selectThemeButton(button: UIButton) {
        button.setTitle("✓", forState: UIControlState.Normal)
    }
    
    private func deselectThemeButton(button: UIButton) {
        button.setTitle("", forState: UIControlState.Normal)
    }

    @IBAction func onDefaultSplitChanged(sender: UIStepper) {
        var split = Int(sender.value)
        defaultSplitNumberLabel.text = split.description
        SettingsHelper.setDefaultSplit(split)
    }
}
