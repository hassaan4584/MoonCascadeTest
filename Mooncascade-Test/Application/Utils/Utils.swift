//
//  Utils.swift
//  Mooncascade-Test
//
//  Created by Hassaan Fayyaz Ahmed on 7/28/19.
//  Copyright © 2019 Hassaan Fayyaz Ahmed. All rights reserved.
//

import Foundation
import Contacts

class Utils {
    
    public static func getAllContacts() -> [String]? {
 
        let contactStore = CNContactStore()
        
        var contacts = [CNContact]()
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        let request = CNContactFetchRequest(keysToFetch: keys)
        
        do {
            try contactStore.enumerateContacts(with: request) {
                (contact, stop) in
                // Array containing all unified contacts from everywhere
                print(contact)
                //                contact.
                contacts.append(contact)
            }
            //            print(contacts)
        }
        catch {
            print("unable to fetch contacts")
        }
        print(contacts.count)
        
        var completeNames: [String]?
        
        for contact in contacts {
            if completeNames == nil {
                completeNames = [String]()
            }
            let name = contact.familyName + " " + contact.givenName
            completeNames!.append(name)
        }
        return completeNames

    }
}
