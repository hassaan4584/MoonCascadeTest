//
//  EmployeeListViewController.swift
//  Mooncascade-Test
//
//  Created by Hassaan Fayyaz Ahmed on 7/25/19.
//  Copyright © 2019 Hassaan Fayyaz Ahmed. All rights reserved.
//

import UIKit
import Contacts

class EmployeeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var employeeTableView: UITableView!
    
    var employeeList: [Employee]?

    var groupedEmployeeList: [EmployeePostion: [Employee]]? {
        get {
            if let employeeList = self.employeeList {
                let list = Dictionary(grouping: employeeList ) { $0.position }
                return list
            }
            return nil
        }
    }
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.employeeTableView.tableFooterView = UIView.init()
        self.employeeTableView.rowHeight = UITableView.automaticDimension
        self.employeeTableView.estimatedRowHeight = 175
        self.employeeTableView.refreshControl = refreshControl
        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshEmployeeList(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString.init(string: "Loading Employees")

        self.fetchEmployeeList()
        self.employeeList = Utils.getEmployeesLocally()
    }
    
    // MARK: API Requests
    
    /// Fetch Latest employee list from server
    private func fetchEmployeeList() {
        
        self.activityIndicator.startAnimating()
        NetworkManager.sharedInstance.getEmployeeList { [weak self] (empContainer, errStr) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.refreshControl.endRefreshing()

                if let errStr = errStr {
                    self?.showAlert(with: "Error", errStr)
                } else {
                   self?.employeeList = empContainer?.employeeList.sorted(by: { (e1, e2) -> Bool in
                        e1.completeName < e2.completeName
                    })
                     
                    self?.employeeTableView.reloadData()
                }
            }
        }
    }

    // MARK: Refresh Control
    @objc private func refreshEmployeeList(_ sender: Any) {
        // Fetch Weather Data
        self.fetchEmployeeList()
    }
    
    // MARK: UITableview
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.groupedEmployeeList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let keys = self.groupedEmployeeList?.keys.sorted(by: {$0.rawValue < $1.rawValue}) {
            for (index, key) in keys.enumerated() {
                if index == section {
                    return self.groupedEmployeeList?[key]?.count ?? 0
                }
            }

        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let keys = self.groupedEmployeeList?.keys.sorted(by: {$0.rawValue < $1.rawValue}) {
            for (index, key) in keys.enumerated() {
                if index == section {
                    return key.rawValue.uppercased()
                }
            }
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell.init()
        if let employeeCell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTVCell", for: indexPath) as? EmployeeTVCell {
            if let keys = self.groupedEmployeeList?.keys.sorted(by: {$0.rawValue < $1.rawValue}) {

                for (index, key) in keys.enumerated() {
                    if index == indexPath.section {
                        let employee = self.groupedEmployeeList?[key]?[indexPath.row]
                        employeeCell.employee = employee
                        
                        employeeCell.onViewContactPressed = { [weak self] in
                            if let employee = employee {
                                self?.openContactDetailPage(forEmployee: employee)
                                print(employee.completeName)
                            }
                        }
                        return employeeCell
                    }
                }
            }

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let keys = self.groupedEmployeeList?.keys.sorted(by: {$0.rawValue < $1.rawValue}) {
            
            for (index, key) in keys.enumerated() {
                if index == indexPath.section {
                    let employee = self.groupedEmployeeList?[key]?[indexPath.row]
                    self.performSegue(withIdentifier: "employeeListToEmployeeDetailSegue", sender: employee)
                }
            }
        }

    }
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? EmployeeDetailsVC, let employee = sender as? Employee {
            destVC.employee = employee
        }
    }
    
    func openContactDetailPage(forEmployee: Employee) {
        
    }

}

