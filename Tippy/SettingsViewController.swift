//
//  SettingsViewController.swift
//  Tippy
//
//  Created by Jonathan Como on 8/29/16.
//  Copyright © 2016 Jonathan Como. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet weak var rememberTipSwitch: UISwitch!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        rememberTipSwitch.on = Settings.rememberTip.get()
    }
    
    @IBAction func onRememberTipChanged(sender: AnyObject) {
        Settings.rememberTip.set(rememberTipSwitch.on)
        if (!rememberTipSwitch.on) {
            Settings.tipPercentage.remove()
        }
    }
}
