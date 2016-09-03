//
//  ViewController.swift
//  Tippy
//
//  Created by Jonathan Como on 8/29/16.
//  Copyright © 2016 Jonathan Como. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(c: CGFloat, m: CGFloat, y: CGFloat, k: CGFloat) {
        let r = (1 - c) * (1 - k)
        let g = (1 - m) * (1 - k)
        let b = (1 - y) * (1 - k)
        
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var tipPercentLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var billView: UIView!

    private var billAmount: Double = 0.0
    private var tipPercentage: Double = 20.0
    
    private let billAmountCacheTimeout: NSTimeInterval = 60
    private let minimumTip: Double = 10
    private let maximumTip: Double = 30
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let lastBillInput = Settings.lastBillTimestamp.get()
        let elapsedTimeSinceBillInput = NSDate().timeIntervalSinceDate(lastBillInput)
        
        if (elapsedTimeSinceBillInput < billAmountCacheTimeout) {
            billAmount = Settings.lastBillAmount.get()
            if billAmount > 0 {
                billField.text = String(format: "%.2f", billAmount)
            }
        }

        // TODO: update tip percent based on saved settings
        updateCurrencyLabels()
        updateDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        billField.becomeFirstResponder()
    }

    @IBAction func onFinishEditing(sender: AnyObject) {
        saveRecentlyEnteredBill()
    }

    @IBAction func onTap(sender: UITapGestureRecognizer) {
        view.endEditing(true);
    }

    @IBAction func calculateTip(sender: AnyObject) {
        billAmount = Double(billField.text!) ?? 0.0
        updateCurrencyLabels()
        updateDisplay()
    }
    
    private func updateDisplay() {
        if billField.text == "" {
            // TODO: use the proper placeholder for the currency
            billField.placeholder = "$"
            hideBillDetails()
        } else {
            showBillDetails()
        }
    }
    
    private func hideBillDetails() {
        UIView.animateWithDuration(0.5,
            animations: {
                self.toggleBillDetailsViewMask(false)
                self.exitBillDetailsView()
            },
            completion: { (finished) in
                self.toggleBillDetailsViewHidden(true)
            }
        )
    }
    
    private func showBillDetails() {
        toggleBillDetailsViewHidden(false)

        UIView.animateWithDuration(0.5,
            animations: {
                self.toggleBillDetailsViewMask(true)
                self.enterBillDetailsView()
            }
        )
    }
    
    private func enterBillDetailsView() {
        let padding: CGFloat = 70
        let newBillAmountCenter = padding + (billField.frame.size.height * 0.5)
        let newTipAmountCenter = newBillAmountCenter + padding
        let newTotalAmountCenter = newTipAmountCenter + (padding * 1.5);
        let newBillViewFrame = CGRectMake(0, 0, view.frame.size.width, newTipAmountCenter + (padding * 0.5))
        
        billField.center.y = newBillAmountCenter
        tipPercentLabel.center.y = newTipAmountCenter
        billView.frame = newBillViewFrame
        totalLabel.center.y = newTotalAmountCenter
    }
    
    private func exitBillDetailsView() {
        let newBillAmountCenter = view.frame.size.height / 3
        let newTipAmountCenter = view.frame.size.height / 2
        let newTotalAmountCenter = view.frame.size.height * 2 / 3
        let newBillViewFrame = CGRectMake(0, 0, view.frame.size.width, newTipAmountCenter + 30)
        
        billField.center.y = newBillAmountCenter
        tipPercentLabel.center.y = newTipAmountCenter
        totalLabel.center.y = newTotalAmountCenter
        billView.frame = newBillViewFrame

    }
    
    private func toggleBillDetailsViewMask(enabled: Bool) {
        let alpha: CGFloat = enabled ? 1 : 0
        
        tipPercentLabel.alpha = alpha
        totalLabel.alpha = alpha
        
        if enabled {
            billView.backgroundColor = backgroundColorForTip()
        } else {
            billView.backgroundColor = UIColor.clearColor()
        }
    }
    
    private func toggleBillDetailsViewHidden(enabled: Bool) {
        tipPercentLabel.hidden = enabled
        totalLabel.hidden = enabled
    }
    
    private func updateCurrencyLabels() {
        let roundedTipPercentage = round(tipPercentage)
        let tip = billAmount * (roundedTipPercentage / 100.0)
        let total = billAmount + tip
        
        tipPercentLabel.text = String(format: "%.0lf%%", roundedTipPercentage)
        totalLabel.text = dollarAmount(total)
    }
    
    func backgroundColorForTip() -> UIColor {
        // We want magenta to go from [0 - 50]% to get a smooth green -> reddish
        let portionOfMaxTip = CGFloat((tipPercentage - minimumTip) / (maximumTip - minimumTip))
        let magenta = (1 - portionOfMaxTip) / 2

        return UIColor(c: 0.18, m: magenta, y: 0.27, k: 0.0)
    }
    
    private func dollarAmount(amount: Double) -> String {
        return NSNumberFormatter.localizedStringFromNumber(amount, numberStyle: .CurrencyStyle)
    }
    
    private func saveRecentlyEnteredBill() {
        Settings.lastBillAmount.set(billAmount)
        Settings.lastBillTimestamp.set(NSDate())
    }
}

