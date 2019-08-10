//
//  Utils.swift
//  Mooncascade-Test
//
//  Created by Hassaan Fayyaz Ahmed on 7/28/19.
//  Copyright © 2019 Hassaan Fayyaz Ahmed. All rights reserved.
//

import Foundation
import Contacts
import ContactsUI

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
                contacts.append(contact)
            }
        }
        catch {
            print("unable to fetch contacts")
        }
        
        var completeNames: [String]?
        
        for contact in contacts {
            if completeNames == nil {
                completeNames = [String]()
            }
            let name = contact.givenName + " " + contact.familyName
            completeNames!.append(name)
        }
        return completeNames

    }
    
    public static func getNativeContact(forName name: String) -> CNContact? {
        
        let contactStore = CNContactStore()
        var contacts = [CNContact]()


        let keys = [CNContactViewController.descriptorForRequiredKeys()]
        let request = CNContactFetchRequest(keysToFetch: keys)
        try? contactStore.enumerateContacts(with: request) {
            (contact, stop) in
            // Array containing all unified contacts from everywhere
            contacts.append(contact)
        }
        
        for contact in contacts {
            let completeName = contact.givenName + " " + contact.familyName
            if completeName == name {
                return contact
            }
        }
        return nil
    }
    
    // MARK: Save and retrieve employee data
    
    /// Save json data of employees in UserDefaults
    static func saveEmployees(withJsonData data: Data?) {
        UserDefaults.standard.set(data, forKey: Constants.EMPLOYEE_DATA_KEY)
    }
    
    /// Retrieve list of employess from UserDefaults
    static func getEmployeesLocally() -> [Employee]? {
        guard let responseData = UserDefaults.standard.object(forKey: Constants.EMPLOYEE_DATA_KEY) as? Data else {
            return nil
        }
        do {
            let apiResponse = try JSONDecoder().decode(EmployeeContainer.self, from: responseData)
            return apiResponse.employeeList
        } catch {
            print(error)
            return nil
        }
    }

}
