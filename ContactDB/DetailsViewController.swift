//
//  DetailsViewController.swift
//  ContactDB
//
//  Created by Parker Greene on 7/1/15.
//  Copyright (c) 2015 Parker Greene. All rights reserved.
//

import Foundation
import UIKit
import AddressBook

class DetailsViewController: UIViewController {
    
    var contact: Contact?
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var companyButton: UIButton!
    let addressBookRef: ABAddressBookRef = ABAddressBookCreateWithOptions(nil,nil).takeRetainedValue()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func makeAndAddContactRecord(contact:Contact) -> ABRecordRef {
        let contactRecord: ABRecordRef = ABPersonCreate().takeRetainedValue()
        ABRecordSetValue(contactRecord, kABPersonFirstNameProperty, contact.firstName, nil)
        ABRecordSetValue(contactRecord, kABPersonLastNameProperty, contact.lastName, nil)
        ABRecordSetValue(contactRecord, kABPersonOrganizationProperty, contact.company, nil)
        
        //use ABMutableMultivalueRef for phone and email since it supports multiple values
        let phoneNumbers: ABMutableMultiValueRef = ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType)).takeRetainedValue()
        ABMultiValueAddValueAndLabel(phoneNumbers, contact.phone, kABPersonPhoneMainLabel, nil)
        ABRecordSetValue(contactRecord, kABPersonPhoneProperty, phoneNumbers, nil)
        let emailAddresses: ABMutableMultiValueRef = ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType)).takeRetainedValue()
        ABMultiValueAddValueAndLabel(emailAddresses, contact.email, nil, nil)
        ABRecordSetValue(contactRecord, kABPersonEmailProperty, emailAddresses, nil)
        ABAddressBookAddRecord(addressBookRef, contactRecord, nil)
        saveAddressBookChanges()
        return contactRecord
        
    }
    
    func saveAddressBookChanges() {
        if ABAddressBookHasUnsavedChanges(addressBookRef){
            var err: Unmanaged<CFErrorRef>? = nil
            let savedToAddressBook = ABAddressBookSave(addressBookRef, &err)
            if savedToAddressBook {
                print("Successfully saved changes")
            }
            else {
                print("Couldn't save changes")
            }
        }
        else {
            print("No changes occurred")
        }
    }
    
    func addContactToContacts(contactButton: UIButton) {
        if let contactRecordIfExists: ABRecordRef = getContactRecord(contact!){
            displayContactExistsAlert(contactRecordIfExists)
            return
        }
        let contactRecord: ABRecordRef = makeAndAddContactRecord(contact!)
        let contactAddedAlert = UIAlertController(title: "\(contact!.firstName) was successfully added",
            message: nil, preferredStyle: .Alert)
        contactAddedAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        presentViewController(contactAddedAlert, animated: true, completion: nil)
    }

    
    func promptForAddressBookRequestAccess(contactButton: UIButton) {
        var err: Unmanaged<CFError>? = nil
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef) {
            (granted: Bool, error: CFError!) in
            dispatch_async(dispatch_get_main_queue()) {
                if !granted {
                    print("just denied")
                    self.displayCantAddContactAlert()
                }
                else {
                    print("just authorized")
                    self.addContactToContacts(contactButton)
                }
            }
        }
    }
    
    @IBAction func tappedAddPetToContacts(contactButton: UIButton) {
        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
        
        switch authorizationStatus {
        case .Denied, .Restricted:
            print("Denied")
            displayCantAddContactAlert()
        case .Authorized:
            print("Authorized")
            addContactToContacts(contactButton)
        case .NotDetermined:
            print("Not Determined")
            promptForAddressBookRequestAccess(contactButton)
        }
    }
    
    func openSettings() {
        let url = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func displayCantAddContactAlert() {
        let cantAddContactAlert = UIAlertController(title: "Cannot Add Contact",
            message: "You must give the app permission to access your contacts.",
            preferredStyle: .Alert)
        cantAddContactAlert.addAction(UIAlertAction(title: "Change Settings",
            style: .Default,
            handler: { action in
                self.openSettings()
        }))
        cantAddContactAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        presentViewController(cantAddContactAlert, animated: true, completion: nil)
    }
    //stores all contacts in an array and cross references new contact with all of them
    func getContactRecord(contact:Contact) -> ABRecordRef? {
        let allContacts = ABAddressBookCopyArrayOfAllPeople(addressBookRef).takeRetainedValue() as Array
        var newContact: ABRecordRef?
        for record in allContacts {
            let currentContact: ABRecordRef = record
            let currentContactName = ABRecordCopyCompositeName(currentContact).takeRetainedValue() as String
            let contactName = contact.name
            if (currentContactName == contactName) {
                print("found \(contactName)")
                newContact = currentContact
            }
        }
        return newContact
    }
    
    func displayContactExistsAlert(contactRecord: ABRecordRef) {
        let contactFirstName = ABRecordCopyValue(contactRecord, kABPersonFirstNameProperty).takeRetainedValue() as? String ?? "This Person"
        let contactExistsAlert = UIAlertController(title: "\(contactFirstName) already exists in contacts", message: nil, preferredStyle: .Alert)
        contactExistsAlert.addAction(UIAlertAction(title: "OK",style: .Cancel, handler: nil))
        presentViewController(contactExistsAlert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.contact?.name
        phoneLabel.text = self.contact?.phone
        emailLabel.text = self.contact?.email
        companyButton.setTitle(self.contact?.company, forState: .Normal)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let companyViewController : CompanyViewController = segue.destinationViewController as? CompanyViewController {
            companyViewController.contact = self.contact
        }
    }
}