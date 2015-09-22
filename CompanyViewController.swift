//
//  CompanyViewController.swift
//  ContactDB
//
//  Created by Parker Greene on 7/3/15.
//  Copyright (c) 2015 Parker Greene. All rights reserved.
//

import Foundation
import UIKit

class CompanyViewController: UIViewController {
    
    var contact: Contact?
    var address: String?
    @IBOutlet weak var addressLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.contact?.company
        //get full address from contact
        let city = self.contact?.city
        let state = self.contact?.state
        let zip = self.contact?.zip
        let address = self.contact?.address
        let city_state_zip = "\(city!) \(state!) \(zip!)"
        let fullAddress = "\(address!)\n\(city_state_zip)"
        self.address = "\(address!) \(city_state_zip)"
        addressLabel.text = fullAddress
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let mapViewController : MapViewController = segue.destinationViewController as? MapViewController {
            mapViewController.address = self.address
            mapViewController.company = self.contact?.company
        }
    }
}