//
//  Extensions.swift
//  Mooncascade-Test
//
//  Created by Hassaan Fayyaz Ahmed on 7/31/19.
//  Copyright © 2019 Hassaan Fayyaz Ahmed. All rights reserved.
//

import Foundation
import UIKit

// MARK: ViewController

extension UIViewController {
    
    func showAlert(with title:String, _ message: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let oKButton = UIAlertAction.init(title: "Ok", style: .default) { (action) in
            
        }
        alert.addAction(oKButton)
        self.present(alert, animated: true, completion: nil)
    }

}
