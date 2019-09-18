//
//  NetworkResponse.swift
//  Mooncascade-Test
//
//  Created by Hassaan Fayyaz Ahmed on 7/25/19.
//  Copyright © 2019 Hassaan Fayyaz Ahmed. All rights reserved.
//

import Foundation

enum MyResult<String> {
    case success
    case failure(String)
}

enum NetworkResponse: String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    case methodNotAllowed = "Method Not Allowed" // make sure correct GET and POST methods are used
    case internalServerError = "Internal Server Error"

}

func handleNetworkResponse(_ response: HTTPURLResponse) -> MyResult<String>{
    switch response.statusCode {
    case 200...299: return .success
    case 405: return .failure("\(response.statusCode) " + NetworkResponse.methodNotAllowed.rawValue)
    case 500: return .failure("\(response.statusCode) " + NetworkResponse.internalServerError.rawValue)
    case 401...500: return .failure("\(response.statusCode) " + NetworkResponse.authenticationError.rawValue)
    case 501...599: return .failure("\(response.statusCode) " + NetworkResponse.badRequest.rawValue)
    case 600: return .failure("\(response.statusCode) " + NetworkResponse.outdated.rawValue)
    default: return .failure("\(response.statusCode) " + NetworkResponse.failed.rawValue)
    }
}

