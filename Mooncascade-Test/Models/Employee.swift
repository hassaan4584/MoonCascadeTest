//
//  Employee.swift
//  Mooncascade-Test
//
//  Created by Hassaan Fayyaz Ahmed on 7/25/19.
//  Copyright © 2019 Hassaan Fayyaz Ahmed. All rights reserved.
//

import Foundation

// MARK: - Employee

struct EmployeeContainer: Decodable {
    let employeeList: [Employee]
    
    enum CodingKeys: String, CodingKey {
        case employeeList = "employees"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        employeeList = try container.decode([Employee].self, forKey: .employeeList)
        
    }
}

struct Employee: Decodable {
    let fname: String
    let lname: String
    let position: String
    let contactDetails: ContactDetails
    
    enum CodingKeys: String, CodingKey {
        case fname = "fname"
        case lname = "lname"
        case position = "position"
        case contactDetails = "contact_details"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fname = try container.decode(String.self, forKey: .fname)
        lname = try container.decode(String.self, forKey: .lname)
        position = try container.decode(String.self, forKey: .position)
        contactDetails = try container.decode(ContactDetails.self, forKey: .contactDetails)
    }
}

// MARK: - ContactDetails
struct ContactDetails: Decodable {
    let email: String
    let phone: String?
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case phone = "phone"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        email = try container.decode(String.self, forKey: .email)
        phone = try container.decodeIfPresent(String.self, forKey: .phone)
    }
}

