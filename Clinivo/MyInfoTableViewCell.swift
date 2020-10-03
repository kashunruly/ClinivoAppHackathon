//
//  MyInfoTableViewCell.swift
//  Clinivo
//
//  Created by Kashlon Palmer on 5/28/20.
//  Copyright © 2020 Kashlon Palmer. All rights reserved.
//

import UIKit

class MyInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var city_and_parish: UILabel!
    @IBOutlet weak var street: UILabel!
    @IBOutlet weak var paient_name: UILabel!
    @IBOutlet weak var edit_info_btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        edit_info_btn.layer.cornerRadius = 17.5
        edit_info_btn.applyShadow()
        
    }


}
