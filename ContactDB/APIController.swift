//
//  APIController.swift
//  ContactDB
//
//  Created by Parker Greene on 7/1/15.
//  Copyright (c) 2015 Parker Greene. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSArray)
    func notValidURL()
}

class APIController {
    
    var newURL: String?
    init(delegate: APIControllerProtocol){
        self.delegate = delegate
        
    }
    
    var delegate: APIControllerProtocol
    func getContactsFromServer(url: String?){
        if url != nil {
            var data: NSArray = []
            //dataURL is url where php script -> (JSON object) is kept
            let url = NSURL(string: url!)
            let downloadedData: NSMutableData? = try? NSMutableData(contentsOfURL: url!, options: [])
            if downloadedData == nil {
                self.delegate.notValidURL()
            }
            else {
                let error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
                do {
                let jsonObject = try NSJSONSerialization.JSONObjectWithData(downloadedData!, options: NSJSONReadingOptions.MutableContainers) as? NSArray
                self.delegate.didReceiveAPIResults(jsonObject!)
                }
                catch {
                    
                    print(error)
                }
            }
        }
        else {
            print("no url given")
        }
    }
}