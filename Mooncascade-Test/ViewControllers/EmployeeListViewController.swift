//
//  EmployeeListViewController.swift
//  Mooncascade-Test
//
//  Created by Hassaan Fayyaz Ahmed on 7/25/19.
//  Copyright © 2019 Hassaan Fayyaz Ahmed. All rights reserved.
//

import UIKit

class EmployeeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var employeeTableView: UITableView!
    
    var employeeList: [Employee]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.employeeTableView.tableFooterView = UIView.init()
        
        self.activityIndicator.startAnimating()
        NetworkManager.sharedInstance.getHomePage { [weak self] (empArr, errStr) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                if let errStr = errStr {
                    print(errStr)
                } else {
                    self?.employeeList = empArr
                    self?.employeeTableView.reloadData()
                    print(empArr)
                }
            }
        }
    }

    // MARK: UITableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.employeeList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.textLabel?.text = self.employeeList![indexPath.row].fname
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    

}

