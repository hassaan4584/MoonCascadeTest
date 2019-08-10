//
//  Employee.swift
//  Mooncascade-Test
//
//  Created by Hassaan Fayyaz Ahmed on 7/25/19.
//  Copyright © 2019 Hassaan Fayyaz Ahmed. All rights reserved.
//

import Foundation

enum EmployeePostion: String {
    case iOS    = "IOS"
    case android = "ANDROID"
    case web    = "WEB"
    case pm     = "PM"
    case tester = "TESTER"
    case sales  = "SALES"
    case other  = "OTHER"
}

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
    let fname:  String
    let lname:  String
    let position:   EmployeePostion
    let projects:   [String]?
    let contactDetails: ContactDetails
    
    enum CodingKeys: String, CodingKey {
        case fname = "fname"
        case lname = "lname"
        case position = "position"
        case projects = "projects"
        case contactDetails = "contact_details"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fname = try container.decode(String.self, forKey: .fname)
        lname = try container.decode(String.self, forKey: .lname)
        projects = try container.decodeIfPresent([String].self, forKey: .projects)
        contactDetails = try container.decode(ContactDetails.self, forKey: .contactDetails)
        
        let post = try container.decode(String.self, forKey: .position)
        position = EmployeePostion.init(rawValue: post) ?? EmployeePostion.other

    }
    
    /// LastName + FirstName
    var completeName: String {
        get {
            let name = self.lname + " " + self.fname
            return name
        }
    }

    /// FirstName + LastName
    var displayName: String {
        get {
            let name = self.fname + " " + self.lname
            return name
        }
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

