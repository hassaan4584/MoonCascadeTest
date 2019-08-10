//
//  EmployeeListViewController.swift
//  Mooncascade-Test
//
//  Created by Hassaan Fayyaz Ahmed on 7/25/19.
//  Copyright © 2019 Hassaan Fayyaz Ahmed. All rights reserved.
//

import UIKit
import ContactsUI


class EmployeeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    // Constants for Storyboard/ViewControllers.

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var employeeTableView: UITableView!
    
    /// The original employeeList received from the server
    var employeeList: [Employee]?
    
    var searchController = UISearchController()
    private let refreshControl = UIRefreshControl()
    

    // MARK: ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.employeeTableView.tableFooterView = UIView.init()
        self.employeeTableView.rowHeight = UITableView.automaticDimension
        self.employeeTableView.estimatedRowHeight = 175

        // Configure Refresh Control
        self.employeeTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshEmployeeList(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString.init(string: "Loading Employees")

        self.fetchEmployeeList()
        self.employeeList = Utils.getEmployeesLocally()
        
        // configure Search controller
        self.setupSearchController()
    }
    
    // MARK: Initialization
    
    /// initialize Search Controller
    private func setupSearchController() {
        searchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.autocapitalizationType = .none
            controller.searchBar.sizeToFit()
            
            if #available(iOS 11.0, *) {
                // For iOS 11 and later, place the search bar in the navigation bar.
                navigationItem.searchController = controller
                
                // Make the search bar always visible.
                navigationItem.hidesSearchBarWhenScrolling = true
            } else {
                // For iOS 10 and earlier, place the search controller's search bar in the table view's header.
                employeeTableView.tableHeaderView = controller.searchBar
            }
            
            return controller
        })()

        /** Specify that this view controller determines how the search controller is presented.
         The search controller should be presented modally and match the physical size of this view controller.
         */
        definesPresentationContext = true

    }

    // MARK: API Requests
    
    /// Fetch Latest employee list from server
    private func fetchEmployeeList() {
        
        self.refreshControl.endRefreshing()
        self.activityIndicator.startAnimating()
        NetworkManager.sharedInstance.getEmployeeList { [weak self] (empContainer, errStr) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                if let errStr = errStr {
                    self?.showAlert(with: "Error", errStr, nil)
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
        // Fetch Employee Data
        self.fetchEmployeeList()
    }
    
    // MARK: SearchController Delegate
    func updateSearchResults(for searchController: UISearchController) {
                
        self.employeeTableView.reloadData()
    }
    // MARK: UITableview
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.groupedEmployeeList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.getEmployees(forSection: section)?.employees?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.getEmployees(forSection: section)?.position ?? ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell.init()
        if let employeeCell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTVCell", for: indexPath) as? EmployeeTVCell {
            
            if let employee = self.getEmployees(forSection: indexPath.section)?.employees?[indexPath.row] {
                employeeCell.employee = employee
                
                employeeCell.onViewContactPressed = { [weak self] in
                        self?.openContactDetailPage(forEmployee: employee)
                }
                return employeeCell
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let employee = self.getEmployees(forSection: indexPath.section)?.employees?[indexPath.row] {
            self.performSegue(withIdentifier: "employeeListToEmployeeDetailSegue", sender: employee)
        }

    }
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? EmployeeDetailsVC, let employee = sender as? Employee {
            destVC.employee = employee
        }
    }
    
    func openContactDetailPage(forEmployee employee: Employee) {
        if let contact = Utils.getNativeContact(forName: employee.completeName) {
            let contactVC = CNContactViewController.init(forUnknownContact: contact)
            contactVC.hidesBottomBarWhenPushed = true
            contactVC.allowsEditing = false
            contactVC.allowsActions = false
            
            self.navigationController?.pushViewController(contactVC, animated: true)
        }
    }
    
    // MARK: Helpers
    
    /// get list of employees and their position/department
    private func getEmployees(forSection section: Int) -> (employees: [Employee]?, position: String?)? {
        
        if let keys = self.groupedEmployeeList?.keys.sorted(by: {$0.rawValue < $1.rawValue}) {
            for (index, key) in keys.enumerated() {
                if index == section {
                    let employees = self.groupedEmployeeList?[key]
                    return (employees, key.rawValue)
                }
            }
        }
        return nil
    }

}


// MARK: - Getters
extension EmployeeListViewController {
    
    /// The employee list filtered based on the text in the search bar controller
    var filtererEmployeeList: [Employee]? {
        get {
            if  (searchController.isActive) {
                return employeeList?.filter({ (employee) -> Bool in
                    guard let text = searchController.searchBar.text, !text.isEmpty else {
                        return true
                    }
                    let fname = employee.fname.lowercased().contains(searchController.searchBar.text?.lowercased() ?? "")
                    let lname = employee.lname.lowercased().contains(searchController.searchBar.text?.lowercased() ?? "")
                    let email = employee.contactDetails.email.lowercased().contains(searchController.searchBar.text?.lowercased() ?? "")
                    let position = employee.position.rawValue.lowercased().contains(searchController.searchBar.text?.lowercased() ?? "")
                    let project = employee.projects?.contains(where: { (project) -> Bool in
                        return project.lowercased().contains(searchController.searchBar.text?.lowercased() ?? "")
                    }) ?? false
                    
                    return fname || lname || email || position || project
                })
            } else {
                return self.employeeList
            }
        }
    }
    
    /// Grouped employess based on their positions
    var groupedEmployeeList: [EmployeePostion: [Employee]]? {
        get {
            if let filtererEmployeeList = self.filtererEmployeeList {
                let list = Dictionary(grouping: filtererEmployeeList ) { $0.position }
                return list
            }
            return nil
        }
    }

}
