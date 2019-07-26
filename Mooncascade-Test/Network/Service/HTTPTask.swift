//
//  HTTPTask.swift
//  Mooncascade-Test
//
//  Created by Hassaan Fayyaz Ahmed on 7/25/19.
//  Copyright © 2019 Hassaan Fayyaz Ahmed. All rights reserved.
//

import Foundation


public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
    
}
