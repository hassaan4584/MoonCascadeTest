//
//  EmployeeDetailsVC.swift
//  Mooncascade-Test
//
//  Created by Hassaan Fayyaz Ahmed on 7/28/19.
//  Copyright © 2019 Hassaan Fayyaz Ahmed. All rights reserved.
//

import UIKit
import ContactsUI

class EmployeeDetailsVC: UIViewController {

    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var positionView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNoLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    @IBOutlet weak var viewContactButton: UIButton!
    
    var employee: Employee?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.updateView(with: self.employee)
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    
    func updateView(with employee: Employee?) {
        guard let employee = employee else {
            return
        }
        self.nameLabel.text = employee.displayName
        self.emailLabel.text = employee.contactDetails.email
        self.phoneNoLabel.text = employee.contactDetails.phone
        self.phoneView.isHidden = employee.contactDetails.phone?.isEmpty ?? true
        self.positionLabel.text = employee.position.rawValue.uppercased()
        if let projects = employee.projects {
            for projectName in projects {
                let label = UILabel.init()
                label.numberOfLines = 0
                label.text = projectName
                
                self.mainStackView.addArrangedSubview(label)
            }
        }
        if let contacts = Utils.getAllContacts() {
            self.viewContactButton.isHidden = !contacts.contains(employee.displayName)
        } else {
            self.viewContactButton.isHidden = true
        }
        
        let height = mainStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        self.contentViewHeightConstraint.constant = height
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: User Interaction
    
    @IBAction func viewContactButtonPressed(_ sender: UIButton) {
        if let employee = employee, let contact = Utils.getNativeContact(forName: employee.displayName) {
            let contactVC = CNContactViewController.init(for: contact)
            contactVC.hidesBottomBarWhenPushed = true
            contactVC.allowsEditing = false
            contactVC.allowsActions = false
            
            self.navigationController?.pushViewController(contactVC, animated: true)
        }
    }
}
