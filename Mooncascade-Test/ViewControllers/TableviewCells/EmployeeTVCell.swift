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
    
    var employee: Employee? {
        didSet {
            self.nameLabel.text = self.employee?.completeName
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
