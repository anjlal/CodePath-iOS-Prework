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

    // FIXME: There must be a better way to do this without repetition...
    @IBOutlet weak var splitTwoWaysLabel: UILabel!
    @IBOutlet weak var splitThreeWaysLabel: UILabel!
    @IBOutlet weak var splitFourWaysLabel: UILabel!

    private var billAmount = 0.0
    private var tipPercentage = 20.0
    
    private var isDisplayingTotal = true
    
    private let billAmountCacheTimeout: NSTimeInterval = 60 * 10
    private let minimumTip = 10.0
    private let maximumTip = 30.0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        initViewsWithSavedData()
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
        if hasEnteredBill() {
            view.endEditing(true);
        }
    }

    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(totalLabel)
        sender.setTranslation(CGPoint(x: 0, y: 0), inView: totalLabel)
        
        let range = maximumTip - minimumTip
        let delta = Double(translation.x / totalLabel.frame.width) * range
        
        tipPercentage += delta
        tipPercentage = min(tipPercentage, maximumTip)
        tipPercentage = max(tipPercentage, minimumTip)
        
        billView.backgroundColor = backgroundColorForTip()
        updateCurrencyLabels()
        
        if sender.state == .Ended {
            Settings.tipPercentage.set(tipPercentage)
        }
    }

    @IBAction func onTapTotal(sender: AnyObject) {
        isDisplayingTotal = !isDisplayingTotal
        updateCurrencyLabels()
        saveRecentlyEnteredBill()
    }

    @IBAction func calculateTip(sender: AnyObject) {
        billAmount = Double(billField.text!) ?? 0.0
        updateCurrencyLabels()
        updateDisplay()
    }
    
    private func initViewsWithSavedData() {
        let lastBillInput = Settings.lastBillTimestamp.get()
        let elapsedTimeSinceBillInput = NSDate().timeIntervalSinceDate(lastBillInput)
        
        if (elapsedTimeSinceBillInput < billAmountCacheTimeout) {
            billAmount = Settings.lastBillAmount.get()
            if billAmount > 0 {
                billField.text = String(format: "%.2f", billAmount)
            }
        }
        
        if (Settings.rememberTip.get()) {
            tipPercentage = Settings.tipPercentage.get()
        }
    }
    
    private func updateDisplay() {
        if hasEnteredBill() {
            showBillDetails()
        } else {
            Settings.lastBillAmount.remove()
            billField.placeholder = localeSpecificCurrencySymbol()
            hideBillDetails()
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
        
        if isDisplayingTotal {
            totalLabel.text = dollarAmount(total)
            totalLabel.textColor = UIColor.blackColor()
        } else {
            totalLabel.text = dollarAmount(tip)
            totalLabel.textColor = UIColor.lightGrayColor()
        }
        
        splitTwoWaysLabel.text = dollarAmount(total * 0.5)
        splitThreeWaysLabel.text = dollarAmount(total * 0.33)
        splitFourWaysLabel.text = dollarAmount(total * 0.25)
    }
    
    private func localeSpecificCurrencySymbol() -> String {
        let symbol = NSLocale.currentLocale().objectForKey(NSLocaleCurrencySymbol)
        return symbol as? String ?? ""
    }
    
    private func backgroundColorForTip() -> UIColor {
        // We want magenta to go from [0 - 50]% to get a smooth green -> reddish
        let portionOfMaxTip = CGFloat((tipPercentage - minimumTip) / (maximumTip - minimumTip))
        let magenta = (1 - portionOfMaxTip) / 2

        return UIColor(c: 0.18, m: magenta, y: 0.27, k: 0.0)
    }
    
    private func dollarAmount(amount: Double) -> String {
        return NSNumberFormatter.localizedStringFromNumber(amount, numberStyle: .CurrencyStyle)
    }
    
    private func hasEnteredBill() -> Bool {
        return billField.text != ""
    }
    
    private func saveRecentlyEnteredBill() {
        Settings.lastBillAmount.set(billAmount)
        Settings.lastBillTimestamp.set(NSDate())
    }
}