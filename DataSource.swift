//
//  DataSource.swift
//  ContactDB
//
//  Created by Parker Greene on 7/9/15.
//  Copyright (c) 2015 Parker Greene. All rights reserved.
//

import Foundation
import UIKit


class DataSource: UIViewController, UITextFieldDelegate{
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet var dataSourceText: UITextField!
    @IBAction func enterButton(sender: AnyObject) {
        dataSourceText.resignFirstResponder()
        //sends new URL to contacts list
        if dataSourceText.text != nil && dataSourceText.text != "" {
            print("source text: \(dataSourceText.text)")
            enteredValue.text = dataSourceText.text
            defaults.setObject(dataSourceText.text, forKey: "dataURL")
            //performSegueWithIdentifier("newURL", sender: self)
            
        }
       
    }
    @IBOutlet var enteredValue: UILabel!
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField == dataSourceText) {
            textField.resignFirstResponder()
        }
        return false
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSourceText.delegate = self
        //Do any additional setup after loading the view
        if let dataURL: String = defaults.stringForKey("dataURL"){
            enteredValue.text = dataURL
        }
        else {
            enteredValue.text = "No Previous URL Found"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newURL" {
            if let viewController: ViewController = segue.destinationViewController as? ViewController {
            viewController.url = dataSourceText.text
            }
        }
    }
}
