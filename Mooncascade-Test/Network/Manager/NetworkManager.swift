//
//  NetworkManager.swift
//  Mooncascade-Test
//
//  Created by Hassaan Fayyaz Ahmed on 7/25/19.
//  Copyright © 2019 Hassaan Fayyaz Ahmed. All rights reserved.
//

import Foundation


fileprivate let DEFAULT_NETWORK_ERROR: String = "Please check your network connection."

struct NetworkManager {
    static let sharedInstance: NetworkManager = NetworkManager()
    static var environment : NetworkEnvironment = .production
    let router = Router<MoonCascadeApi>()
    
    
    
    func getEmployeeList(completion: @escaping (_ employeeContainer: EmployeeContainer?,_ error: String?)->()) {
        let employeeRequet = MoonCascadeApi.getEmployeeList
        router.request(employeeRequet) { data, response, error in
            
            if error != nil {
                completion(nil, error?.localizedDescription ?? DEFAULT_NETWORK_ERROR)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        print("completion(nil, NetworkResponse.noData.rawValue)")
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(EmployeeContainer.self, from: responseData)
                        print("completion(apiResponse.homepage_sections,nil)")
                        completion(apiResponse, nil)
                        return
                    } catch {
                        print("completion(nil, NetworkResponse.unableToDecode.rawValue)")
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
    
    
    
}
