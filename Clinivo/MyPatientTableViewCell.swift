//
//  MyPatientTableViewCell.swift
//  Clinivo
//
//  Created by Kashlon Palmer on 5/30/20.
//  Copyright © 2020 Kashlon Palmer. All rights reserved.
//

import UIKit

class MyPatientTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var city_and_parish: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var paient_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

}
