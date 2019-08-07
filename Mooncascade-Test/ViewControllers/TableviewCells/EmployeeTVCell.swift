//
//  EmployeeTVCell.swift
//  Mooncascade-Test
//
//  Created by Hassaan Fayyaz Ahmed on 7/27/19.
//  Copyright © 2019 Hassaan Fayyaz Ahmed. All rights reserved.
//

import UIKit

class EmployeeTVCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var viewContactButton: UIButton!
    
    var onViewContactPressed: (()-> Void)?
    
    var employee: Employee? {
        didSet {
            self.nameLabel.text = self.employee?.completeName
            
            if let contacts = Utils.getAllContacts(), let employee = self.employee {
                self.viewContactButton.isHidden = !contacts.contains(employee.completeName)
            } else {
                self.viewContactButton.isHidden = true
            }

        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.viewContactButton.addTarget(self, action: #selector(viewContactButtonPressed(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func viewContactButtonPressed(_ sender: UIButton){
        if let onViewContactPressed = self.onViewContactPressed {
            onViewContactPressed()
        }
    }
    
}
