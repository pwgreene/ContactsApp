//
//  Contact.swift
//  ContactDB
//
//  Created by Parker Greene on 7/1/15.
//  Copyright (c) 2015 Parker Greene. All rights reserved.
//

import Foundation
import AddressBook

struct Contact {
    
    let name: String
    let phone: String
    let email: String
    let company: String
    let address: String
    let city: String
    let state: String
    let zip: String
    let firstName: String
    let lastName: String
    //Get First and Last Names from name
    
    
    init(name:String, phone:String, email:String, company: String, address: String, city: String, state: String, zip: String){
        
        self.name = name
        //separate name into first and last names
        let fullNameArr = name.componentsSeparatedByString(" ")
        let firstName:String = fullNameArr[0]
        var lastName: String = ""
        if fullNameArr.count > 1 {
            lastName = fullNameArr[1]
        }
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.email = email
        self.company = company
        self.address = address
        self.city = city
        self.state = state
        self.zip = zip
    }
    
    //returns array of contacts from an array of JSONs
    static func contactsWithJSON(results: NSArray) -> [Contact] {
        //create an empty array of Contacts to append to from this list
        var contacts = [Contact]()
        
        //store the results in our table data array
        if results.count>0 {
            for result in results {
                //Convert the JSONtype to dictionary
                let resultValue = result as! NSDictionary
                //get each value from the dictionary
                let name = result["name"] as? String ?? "None"
                let phone = resultValue["phone"] as? String ?? "None Listed"
                let email = resultValue["email"] as? String ?? "None Listed"
                let company = resultValue["company"] as? String ?? ""
                let address = resultValue["address"] as? String ?? ""
                let city = resultValue["city"] as? String ?? ""
                let state = resultValue["state"] as? String ?? ""
                let zip = resultValue["zip"] as? String ?? ""
                
                //create instance of Contact and add it to the list
                let newContact = Contact(name: name, phone: phone, email: email, company: company, address: address, city: city, state: state, zip: zip)
                contacts.append(newContact)
            }
        }
        contacts.sortInPlace({$0.lastName < $1.lastName})
        return contacts
    }
    
}