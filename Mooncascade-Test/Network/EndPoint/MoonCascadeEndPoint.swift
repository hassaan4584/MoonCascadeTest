//
//  MCEndPoint.swift
//  Mooncascade-Test
//
//  Created by Hassaan Fayyaz Ahmed on 7/25/19.
//  Copyright © 2019 Hassaan Fayyaz Ahmed. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case production
    case staging
}

public enum MoonCascadeApi {
    
    case getEmployeeList
    
}

extension MoonCascadeApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://tallinn-jobapp.aw.ee/" // Production URL
        case .staging: return "" // Staging URL
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .getEmployeeList:
            return "employee_list"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getEmployeeList:
            return .request
        }
    }
    
}

