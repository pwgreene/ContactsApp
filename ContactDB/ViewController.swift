//
//  ViewController.swift
//  ContactDB
//
//  Created by Parker Greene on 7/1/15.
//  Copyright (c) 2015 Parker Greene. All rights reserved.
//
import Foundation
import UIKit
import AddressBook


class ViewController: UIViewController, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol{

    @IBOutlet weak var contactsTableView: UITableView!
    let kCellIdentifier = "ContactCell"
    var api: APIController!
    var contacts = [Contact]()
    var filteredContacts = [Contact]()
    var url: String?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //println(contacts.count)
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return self.filteredContacts.count
        }
        else {
            return self.contacts.count
        }
    }
    
    /*func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ??
    }*/
    
    @IBOutlet var scrollView: UIScrollView!
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.contactsTableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as UITableViewCell!
        var contact: Contact
        //check to see whether the normal table or search results table is being displayed and set the Contact object from the appropriate array
        if tableView == self.searchDisplayController!.searchResultsTableView {
            contact = filteredContacts[indexPath.row]
        }
        else {
            contact = contacts[indexPath.row]
        }
        cell.textLabel?.text = contact.name
        if contact.name == "None" {
            cell.textLabel?.text = "Could not display name"
        }
        cell.detailTextLabel?.text = contact.company
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.contacts = Contact.contactsWithJSON(results)
            self.contactsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    func notValidURL() {
        let dataAlert = UIAlertController(title:"Invalid URL", message: "No data was recieved", preferredStyle: .Alert)
        dataAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        presentViewController(dataAlert, animated: true, completion: nil)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "Name") {
        //filter the table using this method
        self.filteredContacts = self.contacts.filter({(contact: Contact) -> Bool in
            if scope == "Name" {
                let stringMatch = contact.name.rangeOfString(searchText)
                return stringMatch != nil
            }
            else {
                let stringMatch = contact.company.rangeOfString(searchText)
                return stringMatch != nil
            }
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String?) -> Bool {
        let scopes = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]!
        let selectedScope = scopes[self.searchDisplayController!.searchBar.selectedScopeButtonIndex] as String
        self.filterContentForSearchText(searchString!, scope: selectedScope)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        let scope = self.searchDisplayController!.searchBar.scopeButtonTitles as [String]!
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text!, scope: scope[searchOption])
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.hidesBackButton = true
        api = APIController(delegate:self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        //api.getContactsFromServer(url)
        let defaults = NSUserDefaults.standardUserDefaults()
        if let currentURL = defaults.stringForKey("dataURL"){
            api.getContactsFromServer(currentURL)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        //perform actions when this view appears
        api = APIController(delegate:self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        //api.getContactsFromServer(url)
        let defaults = NSUserDefaults.standardUserDefaults()
        if let currentURL = defaults.stringForKey("dataURL"){
            api.getContactsFromServer(currentURL)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "settingsSegue" {
            //do additional setup before segue to settings
        }
        else {
        if let detailsViewController : DetailsViewController = segue.destinationViewController as? DetailsViewController {
            let contactIndex = contactsTableView!.indexPathForSelectedRow!.row
            let selectedContact = self.contacts[contactIndex]
            detailsViewController.contact = selectedContact
        }
        }
    }

    @IBAction func settingsButton(sender: AnyObject) {
        performSegueWithIdentifier("settingsSegue",sender:self)
    }

}

