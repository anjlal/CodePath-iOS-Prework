//
//  ViewController.swift
//  Tippy
//
//  Created by Jonathan Como on 8/29/16.
//  Copyright © 2016 Jonathan Como. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    private var billAmount: Double = 0.0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let lastBillInput = Settings.lastBillTimestamp.get()
        let elapsedTimeSinceBillInput = NSDate().timeIntervalSinceDate(lastBillInput)
        
        if (elapsedTimeSinceBillInput < 60) {
            billAmount = Settings.lastBillAmount.get()
            if billAmount > 0 {
                billField.text = String(format: "%.2f", billAmount)
            }
        }
        
        tipControl.selectedSegmentIndex = Settings.tipIndex.get()
        
        updateCurrencyLabels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        billField.becomeFirstResponder()
    }

    @IBAction func onTap(sender: UITapGestureRecognizer) {
        view.endEditing(true);
        saveRecentlyEnteredBill()
    }

    @IBAction func onTipAmountChanged(sender: AnyObject) {
        if (Settings.rememberTip.get()) {
            Settings.tipIndex.set(tipControl.selectedSegmentIndex)
        }
    }

    @IBAction func calculateTip(sender: AnyObject) {
        billAmount = Double(billField.text!) ?? 0.0
        updateCurrencyLabels()
    }
    
    private func updateCurrencyLabels() {
        let tipPercentages = [0.18, 0.20, 0.25]
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        let tip = billAmount * tipPercentage
        let total = billAmount + tip
        
        tipLabel.text = dollarAmount(tip)
        totalLabel.text = dollarAmount(total)
    }
    
    private func dollarAmount(amount: Double) -> String {
        return NSNumberFormatter.localizedStringFromNumber(amount, numberStyle: .CurrencyStyle)
    }
    
    private func saveRecentlyEnteredBill() {
        Settings.lastBillAmount.set(billAmount)
        Settings.lastBillTimestamp.set(NSDate())
    }
}

