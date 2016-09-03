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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tipControl.selectedSegmentIndex = Settings.tipIndex.get()
        
        let lastBillInput = Settings.lastBillTimestamp.get()
        let elapsedTimeSinceBillInput = NSDate().timeIntervalSinceDate(lastBillInput)
        
        if (elapsedTimeSinceBillInput < 60) {
            billField.text = String(Settings.lastBillAmount.get())
        }
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
        let tipPercentages = [0.18, 0.20, 0.25]
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        let bill = getBillAmount()
        let tip = bill * tipPercentage
        let total = bill + tip
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
    
    func getBillAmount() -> Double {
        return Double(billField.text!) ?? 0.0
    }
    
    func saveRecentlyEnteredBill() {
        Settings.lastBillAmount.set(getBillAmount())
        Settings.lastBillTimestamp.set(NSDate())
    }
}

