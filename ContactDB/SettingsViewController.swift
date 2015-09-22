//
//  SettingsViewController.swift
//  ContactDB
//
//  Created by Parker Greene on 7/9/15.
//  Copyright (c) 2015 Parker Greene. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet var closeSettingsButton: UIButton!
    @IBAction func closeWindow(sender: AnyObject) {
        print("funccancel")
        self.dismissViewControllerAnimated(true, completion: nil)
        //performSegueWithIdentifier("dismissSettings", sender: closeSettingsButton)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "dismissSettings" {
            print("cancel")
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
}